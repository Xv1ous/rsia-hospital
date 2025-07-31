package com.example.hospital.exception;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.NoHandlerFoundException;
import org.apache.catalina.connector.ClientAbortException;

@ControllerAdvice
public class GlobalExceptionHandler {
    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public String handleGeneralException(Exception ex, Model model) {
        // Skip logging for common client abort and favicon errors
        if (ex.getMessage() != null && (ex.getMessage().contains("favicon.ico") ||
                ex.getMessage().contains("Broken pipe") ||
                ex.getMessage().contains("getOutputStream() has already been called"))) {
            return null;
        }

        // Skip logging for ClientAbortException
        if (ex instanceof ClientAbortException) {
            return null;
        }

        // Skip logging for IllegalStateException related to output stream
        if (ex instanceof IllegalStateException &&
                ex.getMessage() != null &&
                ex.getMessage().contains("getOutputStream() has already been called")) {
            return null;
        }

        logger.error("Terjadi kesalahan umum: ", ex);
        model.addAttribute("errorCode", "500");
        model.addAttribute("errorTitle", "Terjadi Kesalahan");
        model.addAttribute("errorMessage",
                "Maaf, terjadi kesalahan di server. Silakan coba lagi beberapa saat.");
        model.addAttribute("errorDetails", "Tim kami sedang memperbaiki masalah ini.");
        return "error/error";
    }

    // Specific handler for ClientAbortException
    @ExceptionHandler(ClientAbortException.class)
    public String handleClientAbortException(ClientAbortException ex) {
        // Don't log this - it's just a client disconnection
        return null;
    }

    // Specific handler for IllegalStateException with output stream
    @ExceptionHandler(IllegalStateException.class)
    public String handleIllegalStateException(IllegalStateException ex) {
        if (ex.getMessage() != null && ex.getMessage().contains("getOutputStream() has already been called")) {
            // Don't log this - it's just a response handling issue
            return null;
        }
        // For other IllegalStateException, let the general handler deal with it
        throw ex;
    }

    @ExceptionHandler(NoHandlerFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public String handleNotFound(NoHandlerFoundException ex, Model model) {
        logger.error("Halaman tidak ditemukan: ", ex);
        model.addAttribute("errorCode", "404");
        model.addAttribute("errorTitle", "Halaman Tidak Ditemukan");
        model.addAttribute("errorMessage", "Maaf, halaman yang Anda cari tidak ditemukan.");
        model.addAttribute("errorDetails", "Silakan periksa URL atau kembali ke halaman utama.");
        return "error/error";
    }

    @ExceptionHandler(java.sql.SQLException.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public String handleDatabaseError(java.sql.SQLException ex, Model model) {
        logger.error("Kesalahan database: ", ex);
        model.addAttribute("errorCode", "500");
        model.addAttribute("errorTitle", "Kesalahan Database");
        model.addAttribute("errorMessage", "Maaf, terjadi kesalahan pada database.");
        model.addAttribute("errorDetails", "Tim kami sedang memperbaiki masalah ini.");
        return "error/error";
    }

    @ExceptionHandler(org.springframework.validation.BindException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public String handleValidationError(org.springframework.validation.BindException ex,
            Model model) {
        logger.error("Kesalahan validasi: ", ex);
        model.addAttribute("errorCode", "400");
        model.addAttribute("errorTitle", "Data Tidak Valid");
        model.addAttribute("errorMessage", "Maaf, data yang Anda masukkan tidak valid.");
        model.addAttribute("errorDetails", "Silakan periksa kembali data yang Anda masukkan.");
        return "error/error";
    }
}
