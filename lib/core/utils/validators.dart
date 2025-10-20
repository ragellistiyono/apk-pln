/// Input validation utilities
library;

import '../constants/app_constants.dart';

/// Validation utilities for forms
class Validators {
  Validators._(); // Private constructor

  /// Validate username
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username tidak boleh kosong';
    }

    if (value.trim().length < 3) {
      return 'Username minimal 3 karakter';
    }

    return null;
  }

  /// Validate NIP
  static String? validateNip(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'NIP tidak boleh kosong';
    }

    if (value.trim().length < AppConstants.minNipLength) {
      return 'NIP minimal ${AppConstants.minNipLength} karakter';
    }

    if (value.trim().length > AppConstants.maxNipLength) {
      return 'NIP maksimal ${AppConstants.maxNipLength} karakter';
    }

    // Check if contains only alphanumeric
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value.trim())) {
      return 'NIP hanya boleh berisi huruf dan angka';
    }

    return null;
  }

  /// Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'Password minimal ${AppConstants.minPasswordLength} karakter';
    }

    return null;
  }

  /// Validate ticket description
  static String? validateTicketDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Deskripsi tidak boleh kosong';
    }

    if (value.trim().length < AppConstants.minDescriptionLength) {
      return 'Deskripsi minimal ${AppConstants.minDescriptionLength} karakter';
    }

    if (value.trim().length > AppConstants.maxDescriptionLength) {
      return 'Deskripsi maksimal ${AppConstants.maxDescriptionLength} karakter';
    }

    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  /// Validate email format (for future use)
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }

    return null;
  }

  /// Validate phone number (Indonesian format)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }

    // Remove spaces and dashes
    final cleanNumber = value.replaceAll(RegExp(r'[\s-]'), '');

    // Check if starts with 0 or +62 or 62
    if (!RegExp(r'^(0|\+?62)[0-9]{8,12}$').hasMatch(cleanNumber)) {
      return 'Format nomor telepon tidak valid';
    }

    return null;
  }

  /// Validate minimum length
  static String? validateMinLength(String? value, int minLength, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    if (value.trim().length < minLength) {
      return '$fieldName minimal $minLength karakter';
    }

    return null;
  }

  /// Validate maximum length
  static String? validateMaxLength(String? value, int maxLength, String fieldName) {
    if (value != null && value.trim().length > maxLength) {
      return '$fieldName maksimal $maxLength karakter';
    }

    return null;
  }
}