package com.example.LTJava.outcome.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.LTJava.outcome.dto.PloDto;
import com.example.LTJava.outcome.dto.PloUpsertReq;
import com.example.LTJava.outcome.service.PloService;

@RestController
@RequestMapping("/api/aa/plos")
@PreAuthorize("hasRole('AA')")
public class AaPloController {

    private final PloService ploService;

    public AaPloController(PloService ploService) {
        this.ploService = ploService;
    }

    @GetMapping
    public ResponseEntity<List<PloDto>> list(@RequestParam String scopeKey) {
        return ResponseEntity.ok(ploService.listAll(scopeKey));
    }

    @PostMapping
    public ResponseEntity<PloDto> create(@RequestBody PloUpsertReq req) {
        return ResponseEntity.ok(ploService.create(req));
    }

    @PutMapping("/{id}")
    public ResponseEntity<PloDto> update(@PathVariable Long id, @RequestBody PloUpsertReq req) {
        return ResponseEntity.ok(ploService.update(id, req));
    }

    @DeleteMapping("/{id}/hard")
    public ResponseEntity<Void> hardDelete(@PathVariable Long id) {
        ploService.hardDelete(id);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        ploService.softDelete(id);
        return ResponseEntity.noContent().build();
    }
}
