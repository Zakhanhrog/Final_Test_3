package com.example.library.dao;

import com.example.library.config.DatabaseConnector;
import com.example.library.model.Student;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {
    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        String query = "SELECT * FROM Student";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                students.add(new Student(
                        rs.getString("student_id"),
                        rs.getString("full_name"),
                        rs.getString("class_name")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return students;
    }

    public Student getStudentById(String studentId) {
        Student student = null;
        String query = "SELECT * FROM Student WHERE student_id = ?";
        try (Connection conn = DatabaseConnector.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    student = new Student(
                            rs.getString("student_id"),
                            rs.getString("full_name"),
                            rs.getString("class_name")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return student;
    }
}