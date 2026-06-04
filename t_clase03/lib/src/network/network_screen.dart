import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models.dart';
import 'network_service.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  final NetworkService _service = NetworkService();
  final TextEditingController _idController = TextEditingController(text: '1');
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final FocusNode _bodyFocusNode = FocusNode();

  PostModel? _post;
  bool _isLoading = false;

  @override
  void dispose() {
    _idController.dispose();
    _titleController.dispose();
    _bodyController.dispose();
    _bodyFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NetworkScreen')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Comunicación HTTP con JSONPlaceholder',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _idController,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _isLoading ? null : _fetchPost,
                    child: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                          )
                        : const Text('Obtener'),
                  ),
                ],
              ),
              if (_isLoading) ...[
                const SizedBox(height: 16),
                const LinearProgressIndicator(),
              ],
              const SizedBox(height: 20),
              TextField(
                controller: _titleController,
                enabled: _post != null && !_isLoading,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _bodyController,
                enabled: _post != null && !_isLoading,
                focusNode: _bodyFocusNode,
                maxLines: 7,
                decoration: const InputDecoration(
                  labelText: 'Body',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _post == null || _isLoading ? null : _updatePost,
                icon: const Icon(Icons.upload),
                label: const Text('Actualizar'),
              ),
              const SizedBox(height: 16),
              if (_post != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Text(
                    'Post actual: ID ${_post!.id}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchPost() async {
    final id = int.tryParse(_idController.text.trim());
    if (id == null || id <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingresa un ID válido.')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final post = await _service.fetchPost(id);
      if (!mounted) {
        return;
      }

      setState(() {
        _post = post;
        _idController.text = post.id.toString();
        _titleController.text = post.title;
        _bodyController.text = post.body;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updatePost() async {
    final post = _post;
    if (post == null) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      final payload = post.copyWith(
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
      );
      final updatedPost = await _service.updatePost(payload);
      if (!mounted) {
        return;
      }

      setState(() {
        _post = updatedPost;
        _titleController.text = updatedPost.title;
        _bodyController.text = updatedPost.body;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Post actualizado correctamente.')));
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
