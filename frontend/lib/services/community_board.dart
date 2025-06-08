/// =============================================================
/// File : community_board.dart
/// Desc : 게시글 및 댓글 관련 API 함수 정의
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-06-07
/// Updt : 2025-06-08
/// =============================================================

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scholarai/constants/config.dart';

class CommunityBoardService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<List<Map<String, dynamic>>> fetchPosts() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/posts'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      final posts = data.cast<Map<String, dynamic>>();
      return posts.reversed.toList();
    } else {
      throw Exception('게시글 목록을 불러오지 못했습니다');
    }
  }

  static Future<Map<String, dynamic>> fetchPost(int postId) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/api/posts/$postId');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    debugPrint('📮 [fetchPost] statusCode: ${response.statusCode}');
    debugPrint('📮 [fetchPost] body: ${response.body}');
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['data'];
    } else {
      throw Exception('게시글을 불러오지 못했습니다');
    }
  }

  static Future<int> createPost(String title, String content) async {
    final token = await _getToken();
    debugPrint('📌 token: $token');
    final response = await http.post(
      Uri.parse('$baseUrl/api/posts'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'title': title, 'content': content}),
    );
    debugPrint('📮 statusCode: ${response.statusCode}');
    debugPrint('📮 body: ${response.body}');
    if (response.statusCode == 201) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('게시글 등록 실패');
    }
  }

  static Future<void> updatePost(
    int postId,
    String title,
    String content,
  ) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/api/posts/$postId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'title': title, 'content': content}),
    );
    if (response.statusCode != 200) {
      throw Exception('게시글 수정 실패');
    }
  }

  static Future<void> deletePost(int postId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('로그인 정보가 없습니다.');
    }
    final response = await http.delete(
      Uri.parse('$baseUrl/api/posts/$postId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('게시글 삭제 실패');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchComments(int postId) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/api/posts/$postId/comments');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      throw Exception('댓글 목록 조회 실패');
    }
  }

  static Future<int> createComment(int postId, String content) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/posts/$postId/comments'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'content': content}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('댓글 등록 실패');
    }
  }

  static Future<void> updateComment(int commentId, String content) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/api/comments/$commentId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'content': content}),
    );
    if (response.statusCode != 200) {
      throw Exception('댓글 수정 실패');
    }
  }

  static Future<void> deleteComment(int commentId) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/comments/$commentId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('댓글 삭제 실패');
    }
  }
}
