package com.example.LTJava.syllabus.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.LTJava.syllabus.entity.SyllabusContent;
import com.example.LTJava.syllabus.service.SyllabusContentService;

@RestController
@RequestMapping("/api/syllabus/{syllabusId}/content")
public class SyllabusContentViewController {

    private final SyllabusContentService syllabusContentService;

    public SyllabusContentViewController(SyllabusContentService syllabusContentService) {
        this.syllabusContentService = syllabusContentService;
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('LECTURER','HOD','AA','PRINCIPAL','SYSTEM_ADMIN','STUDENT')")
    public ResponseEntity<SyllabusContent> get(@PathVariable Long syllabusId) {
        return ResponseEntity.ok(syllabusContentService.getBysyllabusId(syllabusId));
    }
}
