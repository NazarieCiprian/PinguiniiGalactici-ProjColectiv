import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LandingPageComponent } from './lading-page/landing-page.component';
import { SharedModule } from './_modules/shared/shared.module';
import { AboutUsPageComponent } from './_modules/about-us-page/about-us-page.component';

const routes: Routes = [
    {
        path: '',
        component: LandingPageComponent
    },
    {
        path: 'about',
        component: AboutUsPageComponent
    },
    {
        path: 'login/student',
        loadChildren: '../app/_modules/student-login-module/student-login.module#StudentLoginModule'
    },
    {
        path: 'login/teacher',
        loadChildren: '../app/_modules/teacher-login-module/teacher-login.module#TeacherLoginModule'
    },
    {
        path: 'teacher/main-page',
        loadChildren: '../app/_modules/teacher-main-page/teacher-main-page.module#TeacherMainPageModule'
    },
    {
        path: 'teacher/create-user',
        loadChildren: '../app/_modules/create-user/create-user.module#CreateUserModule'
    },
    {
        path: 'teacher/assign-students',
        loadChildren: '../app/_modules/assign-student/assign-student.module#AssignStudentModule'
    },
    {
        path: 'teacher/create-group',
        loadChildren: '../app/_modules/assign-group/assign-group.module#AssignGroupModule'
    },
    {
        path: 'teacher/grade-student',
        loadChildren: '../app/_modules/teacher-grade-student/teacher-grade-student.module#TeacherGradeStudentModule'

    },
    {
        path: 'teacher/courses',
        loadChildren: '../app/_modules/teacher-courses/teacher-courses.module#TeacherCoursesModule'
    },
    {
        path: 'student',
        loadChildren: '../app/_modules/student-courses/student-courses.module#StudentCoursesModule'
    },
    {
        path: 'teacher/reports',
        loadChildren: '../app/_modules/reports/reports.module#ReportsModule'
    },
    {
        path: 'lazy',
        loadChildren: '../app/_modules/lazy-module/lazy.module#LazyModule'
    }
];
@NgModule({
    imports: [
        RouterModule.forRoot(routes, {enableTracing: false}), // enableTracing debuging purpose
    ],
    exports: [
        RouterModule
    ],
    providers: []

})
export class AppRoutingModule {}
