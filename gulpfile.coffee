gulp       = require 'gulp'
connect    = require 'gulp-connect'
concat     = require 'gulp-concat'
jade       = require 'gulp-jade'
coffee     = require 'gulp-coffee'
stripDebug = require 'gulp-strip-debug'
uglify     = require 'gulp-uglify'
imagemin   = require 'gulp-imagemin'
less       = require 'gulp-less'
csso       = require 'gulp-csso'
gutil      = require 'gulp-util'
modRewrite = require 'connect-modrewrite'
pngcrush   = require 'imagemin-pngcrush'
template   = require 'gulp-angular-templatecache'
livereload = require 'gulp-livereload'

  
#combine all template files of the app into a js file
gulp.task 'templates', ->
  gulp.src(['./app/templates/**/*.jade'])
  .pipe(jade().on('error', gutil.log))
  .pipe(template('templates.js', standalone: true).on('error', gutil.log))
  .pipe(gulp.dest('./public/assets'))


# Compile Jade > html
gulp.task 'jade', ->
  gulp.src('app/jade/index.jade')
  .pipe(jade().on('error', gutil.log))
  .pipe(gulp.dest('./public'))


# Compile CoffeeScript > JS
gulp.task 'coffee', ->
  gulp.src('./app/**/*.coffee')
  .pipe(coffee(bare: true).on('error', gutil.log))
  .pipe(concat('app.js'))
  .pipe(gulp.dest('./public/assets'))

gulp.task 'fonts', ->
  gulp.src(['bower_components/fontawesome/fonts/fontawesome-webfont.*'])
  .pipe(gulp.dest('./public/fonts'))

gulp.task 'images', ->
  #  .pipe(imagemin({ progressive: true, use: [pngcrush()] }).on('error', gutil.log))
  gulp.src(['./app/images/*.png', './app/images/*.jpg'])
  .pipe(gulp.dest('./public/assets/images'))

gulp.task 'favicon', ->
  gulp.src(['./app/images/favicon.ico'])
  .pipe(gulp.dest('./public/'))


# Compiles LESS > CSS 
gulp.task 'less', ->
  gulp.src(['app/less/*.less'])
  .pipe(less({ sourceMap: true,  paths: ['./bower_components']})).on('error', gutil.log)
   #.pipe(csso().on('error', gutil.log))
  .pipe(gulp.dest('./public/assets'))

gulp.task 'js', ->
  gulp.src( [
    './bower_components/jquery/dist/jquery.js'
    './bower_components/bootstrap/dist/js/bootstrap.js'
    './bower_components/angular/angular.js'
    './bower_components/angular-resource/angular-resource.js'
    './bower_components/angular-cookies/angular-cookies.js'
    './bower_components/angular-route/angular-route.js'
    './bower_components/angular-loading-bar/src/loading-bar.js'
    './bower_components/angular-ui-router/release/angular-ui-router.js'
    './bower_components/angular-animate/angular-animate.js'
    'bower_components/angular-payments/lib/angular-payments.js'
    # Pick one.
    './bower_components/angular-growl-notifications/dist/growl-notifications.js'
    './bower_components/angular-growl/build/angular-growl.js'
  ])
  .pipe(concat('lib.js'))
  .pipe(gulp.dest('./public/assets'))


gulp.task 'watch', ->
  livereload.listen()
  gulp.watch([
    'public/**/*.html'
    'public/assets/**.js'
    'public/assets/**.css'
    'public/assets/templates.js'
  ]).on('change', livereload.changed)

  gulp.watch [
    'app/**/*.coffee'
    '!app/**/*test.coffee'
  ], ['coffee']

  gulp.watch [
    './app/templates/**/*.jade'
  ], ['templates']

  gulp.watch [
    'app/less/*.less'
    'bower_components/**/*.less'
  ], ['less']

  gulp.watch [
    'app/jade/**.jade'
  ], ['jade']

  gulp.watch [
    'app/images/*'
  ],['images']

gulp.task 'connect', ->
  connect.server
    #Allow for Angularjs paths. dirty check for extension.
    middleware: -> [modRewrite [ '^[^.]*$ /index.html' ]]
    livereload: false
    root: ['public']
    host: '0.0.0.0'
    port: 3000

gulp.task 'build', [
  'favicon'
  'templates'
  'images'
  'js'
  'fonts'
  'less'
  'images'
  'coffee'
  'jade'
]

gulp.task 'live', [
  'build'
  'watch'
]

gulp.task 'default', [
  'live'
  'connect'
]
