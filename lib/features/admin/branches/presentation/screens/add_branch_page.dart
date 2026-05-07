// ─────────────────────────────────────────────────────────────────────────────
// FILE: pages/add_branch_page.dart  (GA-429)
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/branches_bloc.dart';
import '../../domain/usecase/create_branch_usecase.dart';
import '../bloc/branches_event.dart';
import '../bloc/branches_state.dart';

class AddBranchPage extends StatefulWidget {
  const AddBranchPage({super.key});

  @override
  State<AddBranchPage> createState() => _AddBranchPageState();
}

class _AddBranchPageState extends State<AddBranchPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameCtrl    = TextEditingController();
  final _cityCtrl    = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _addressCtrl = TextEditingController();

  String? _openingTime;   // HH:mm
  String? _closingTime;   // HH:mm
  String  _status = 'ACTIVE';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cityCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF1A1A2E)),
        title: const Text(
          'Add Branch',
          style: TextStyle(
              color: Color(0xFF1A1A2E),
              fontWeight: FontWeight.w700,
              fontSize: 18),
        ),
      ),
      body: BlocListener<BranchesBloc, BranchesState>(
        listenWhen: (_, curr) =>
        curr is BranchCreated || curr is BranchCreateError,
        listener: (ctx, state) {
          if (state is BranchCreated) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              const SnackBar(
                content: Text('Branch created successfully'),
                backgroundColor: Color(0xFF10B981),
              ),
            );
            Navigator.pop(ctx, true); // true = reload the list
          } else if (state is BranchCreateError) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _FormCard(children: [
                  const _SectionTitle('Basic Information'),
                  const SizedBox(height: 12),
                  _buildField(
                    controller: _nameCtrl,
                    label: 'Branch Name',
                    hint: 'e.g. Mumbai Central',
                    validator: (v) =>
                    v == null || v.isEmpty ? 'Branch name is required' : null,
                  ),
                  const SizedBox(height: 12),
                  _buildField(
                    controller: _cityCtrl,
                    label: 'City / Location',
                    hint: 'e.g. Mumbai',
                    validator: (v) =>
                    v == null || v.isEmpty ? 'City is required' : null,
                  ),
                ]),
                const SizedBox(height: 12),
                _FormCard(children: [
                  const _SectionTitle('Contact Information'),
                  const SizedBox(height: 12),
                  _buildField(
                    controller: _phoneCtrl,
                    label: 'Phone',
                    hint: '+91 98765 43210',
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                    v == null || v.isEmpty ? 'Phone is required' : null,
                  ),
                  const SizedBox(height: 12),
                  _buildField(
                    controller: _emailCtrl,
                    label: 'Email',
                    hint: 'branch@gymapp.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Email is required';
                      final emailReg = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailReg.hasMatch(v)) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildField(
                    controller: _addressCtrl,
                    label: 'Address',
                    hint: '123 MG Road, Mumbai',
                    maxLines: 3,
                    validator: (v) =>
                    v == null || v.isEmpty ? 'Address is required' : null,
                  ),
                ]),
                const SizedBox(height: 12),
                _FormCard(children: [
                  const _SectionTitle('Operating Hours'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _TimePicker(
                          label: 'Opening Time',
                          value: _openingTime,
                          onPicked: (t) =>
                              setState(() => _openingTime = t),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _TimePicker(
                          label: 'Closing Time',
                          value: _closingTime,
                          onPicked: (t) =>
                              setState(() => _closingTime = t),
                        ),
                      ),
                    ],
                  ),
                  if (_openingTime != null &&
                      _closingTime != null &&
                      !_closingAfterOpening())
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Closing time must be after opening time',
                        style:
                        TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ]),
                const SizedBox(height: 12),
                _FormCard(children: [
                  const _SectionTitle('Status'),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: _dropdownDecoration(),
                    items: const [
                      DropdownMenuItem(
                          value: 'ACTIVE', child: Text('Active')),
                      DropdownMenuItem(
                          value: 'INACTIVE', child: Text('Inactive')),
                    ],
                    onChanged: (v) => setState(() => _status = v ?? 'ACTIVE'),
                  ),
                ]),
                const SizedBox(height: 24),
                BlocBuilder<BranchesBloc, BranchesState>(
                  builder: (context, state) {
                    final isLoading = state is BranchCreating;
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2),
                        )
                            : const Text(
                          'Create Branch',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    if (_openingTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an opening time')),
      );
      return;
    }
    if (_closingTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a closing time')),
      );
      return;
    }
    if (!_closingAfterOpening()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Closing time must be after opening time')),
      );
      return;
    }

    context.read<BranchesBloc>().add(
      SubmitCreateBranch(
        CreateBranchParams(
          name: _nameCtrl.text.trim(),
          city: _cityCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          address: _addressCtrl.text.trim(),
          openingTime: _openingTime!,
          closingTime: _closingTime!,
          status: _status,
        ),
      ),
    );
  }

  bool _closingAfterOpening() {
    if (_openingTime == null || _closingTime == null) return true;
    final toMins = (String hhmm) {
      final p = hhmm.split(':');
      return int.parse(p[0]) * 60 + int.parse(p[1]);
    };
    return toMins(_closingTime!) > toMins(_openingTime!);
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }
}

// ── Supporting form widgets ───────────────────────────────────────────────────
class _FormCard extends StatelessWidget {
  final List<Widget> children;
  const _FormCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 15,
          color: Color(0xFF1A1A2E)),
    );
  }
}

class _TimePicker extends StatelessWidget {
  final String label;
  final String? value;
  final ValueChanged<String> onPicked;

  const _TimePicker(
      {required this.label, required this.value, required this.onPicked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) {
          // Convert to HH:mm string
          final h = picked.hour.toString().padLeft(2, '0');
          final m = picked.minute.toString().padLeft(2, '0');
          onPicked('$h:$m');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, size: 18, color: Colors.grey[500]),
            const SizedBox(width: 8),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              Text(
                value ?? 'HH:mm',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: value != null
                        ? const Color(0xFF1A1A2E)
                        : Colors.grey[400]),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}