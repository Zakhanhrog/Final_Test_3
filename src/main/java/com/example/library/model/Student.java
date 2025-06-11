package com.example.library.model;

public class Student {
    private String studentId;
    private String fullName;
    private String className;

    public Student() {
    }

    public Student(String studentId, String fullName, String className) {
        this.studentId = studentId;
        this.fullName = fullName;
        this.className = className;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }
}