import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TeacherGradeStudentRoutingModule } from './teacher-grade-student-routing.module';
import { SharedModule } from '../shared/shared.module';
import { TeacherGradeStudentPageComponent } from './pages/teacher-grade-student.page';
import { MatToolbarModule, MatFormFieldModule,
    MatInputModule, MatIconModule,
    MatButtonModule, MatSidenavModule, MatCheckboxModule,
    MatAutocompleteModule, MatTableModule, MatSortModule, MatTabsModule, MatSelectModule, MatListModule } from '@angular/material';
import { ReactiveFormsModule, FormsModule } from '@angular/forms';
import { TeacherGradeService } from './services/teacher-grade.service';
import { GradeStudentComponent } from './components/grade-student/grade-student.component';


@NgModule({
    imports: [
        CommonModule,
        SharedModule,
        TeacherGradeStudentRoutingModule,
        MatToolbarModule,
        MatFormFieldModule,
        MatInputModule,
        MatIconModule,
        MatButtonModule,
        MatSidenavModule,
        MatCheckboxModule,
        MatAutocompleteModule,
        ReactiveFormsModule,
        MatTableModule,
        MatSortModule,
        MatTabsModule,
        SharedModule,
        FormsModule,
        MatSelectModule,
        MatListModule
    ],
    declarations: [
        TeacherGradeStudentPageComponent,
        GradeStudentComponent
    ],
    providers: [
        TeacherGradeService,
    ]
})
export class TeacherGradeStudentModule {}
