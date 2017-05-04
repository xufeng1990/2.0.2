var gulp = require('gulp'),
	gutil = require('gulp-util'),
	autoprefixer = require('gulp-autoprefixer'),
	less = require('gulp-less'),
	mincss = require('gulp-minify-css'),
	minimg = require('gulp-imagemin'),
	minhtml = require('gulp-htmlmin'),
	uglify = require('gulp-uglify'),
	rename = require('gulp-rename'),
	replace = require('gulp-replace'),
	clean = require('gulp-rimraf'),
	concat = require('gulp-concat'),
	cheerio = require('gulp-cheerio'),
	jeditor = require('gulp-json-editor'),
	strip = require('gulp-strip-debug');

gulp.task('clean-css', function() {
	return gulp.src(['dist/css'], {
		read: false
	}).pipe(clean({
		force: true
	}));
});

gulp.task('css', ['clean-css'], function() {
	gulp.src(['src/less/**/*.less', '!src/less/style-example.less'])
		.pipe(less())
		.pipe(autoprefixer({
			browsers: ['last 2 versions', 'Android >= 2.3', 'ios 7', 'ios 8', 'ios 9'],
			cascade: true,
			remove: false
		}))
		.pipe(concat('style.css'))
		.pipe(mincss())
		.pipe(gulp.dest('dist/css'));
	gulp.src(['src/less/style-example.less'])
		.pipe(less())
		.pipe(autoprefixer({
			browsers: ['last 2 versions', 'Android >= 2.3', 'ios 7', 'ios 8', 'ios 9'],
			cascade: true,
			remove: false
		}))
		.pipe(concat('style-example.css'))
		.pipe(mincss())
		.pipe(gulp.dest('dist/css'));
});

gulp.task('html', function() {
	gulp.src(['src/html/**/*.html'])
		.pipe(minhtml({
			removeComments: true,
			removeCommentsFromCDATA: true,
			removeCDATASectionsFromCDATA: true,
			collapseWhitespace: true,
			useShortDoctype: true,
			removeScriptTypeAttributes: true,
			removeStyleLinkTypeAttributes: true,
			minifyJS: true,
			minifyCSS: true
		}))
		.pipe(gulp.dest('dist/html'));
});

gulp.task('default', function() {
	gutil.log('\r\n');
	gulp.run(
		'css',
		'html'
	);
});