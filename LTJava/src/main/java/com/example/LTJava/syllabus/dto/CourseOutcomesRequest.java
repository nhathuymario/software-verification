package com.example.LTJava.syllabus.dto;

import java.util.List;
import java.util.Map;

public record CourseOutcomesRequest(
        Map<String, String> generalInfo,
        String description,
        List<String> courseObjectives,
        List<Map<String, String>> courseLearningOutcomes,
        List<Map<String, String>> assessmentMethods,
        String studentDuties,
        List<Map<String, String>> teachingPlan,
        List<Map<String, Object>> cloMappings
) {}
