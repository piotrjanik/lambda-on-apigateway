const gulp = require('gulp');
const addsrc = require('gulp-add-src');
const debug = require('gulp-debug');
const size = require('gulp-size');
const gutil = require('gulp-util');

const zip = require('gulp-zip');
const pkg = require('./package.json');

const del = require('del');
const install = require('gulp-install');
const tslint = require('gulp-tslint');

const ts = require('gulp-typescript');

const tsProject = ts.createProject('tsconfig.json');
const dist = 'dist';
gulp.task('clean', () => {
    return del(['build', dist]);
});

gulp.task('lint', gulp.series('clean', () => {
    return gulp.src(['app/**/*.ts'])
        .pipe(tslint({formatter: 'stylish', fix: false}))
        .pipe(tslint.report({
            emitError: true,
            summarizeFailureOutput: true
        }))
}));
gulp.task('compile', gulp.series('lint', (done) => {
    const tsResult = gulp.src('app/**/*.ts')
        .pipe(tsProject())
        .on('error', (err) => {
            throw err
        });
    return tsResult.js.pipe(debug({title: 'ts'}))
        .pipe(gulp.dest('dist'))
        .pipe(size({title: 'compile'}))
        .resume()
        .on('end', done)

}));

gulp.task('install', gulp.series('compile', () => {
    return gulp.src(['./package.json', './package-lock.json'])
        .pipe(gulp.dest(dist))
        .pipe(install({production: true}))
}));

gulp.task('package', gulp.series('install', () => {
    const artifactName = `${pkg.name}.zip`;
    const files = [
        `./${dist}/**`,
        `!./${dist}/node_modules/**/.bin`,
        `!./${dist}/node_modules/**/.bin/**`
    ];
    return gulp.src(files, {base: dist, dot: true})
        .pipe(zip(artifactName))
        .pipe(gulp.dest('build'));
}));