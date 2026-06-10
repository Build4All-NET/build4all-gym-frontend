import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/branches_bloc.dart';
import '../../domain/entity/branch_detail_entity.dart';
import '../../domain/usecase/create_branch_usecase.dart';
import '../../domain/usecase/update_branch_usecase.dart';
import '../bloc/branches_event.dart';
import '../bloc/branches_state.dart';

class AddBranchPage extends StatefulWidget {
  final BranchDetailEntity? existing;
  const AddBranchPage({super.key, this.existing});

  @override
  State<AddBranchPage> createState() => _AddBranchPageState();
}

class _AddBranchPageState extends State<AddBranchPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _addressCtrl;

  String? _openingTime;
  String? _closingTime;
  bool    _isOpen24Hours = false;
  String  _status = 'ACTIVE';

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl      = TextEditingController(text: e?.name ?? '');
    _cityCtrl      = TextEditingController(text: e?.city ?? '');
    _phoneCtrl     = TextEditingController(text: e?.phone ?? '');
    _emailCtrl     = TextEditingController(text: e?.email ?? '');
    _addressCtrl   = TextEditingController(text: e?.address ?? '');
    _openingTime   = e?.openingTime;
    _closingTime   = e?.closingTime;
    _isOpen24Hours = e?.isOpen24Hours ?? false;
    _status        = e?.status ?? 'ACTIVE';
  }

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
        title: Text(
          _isEdit ? 'Edit Branch' : 'Add Branch',
          style: const TextStyle(
              color: Color(0xFF1A1A2E),
              fontWeight: FontWeight.w700,
              fontSize: 18),
        ),
      ),
      body: BlocListener<BranchesBloc, BranchesState>(
        listenWhen: (_, curr) =>
            curr is BranchCreated ||
            curr is BranchCreateError ||
            curr is BranchUpdated ||
            curr is BranchUpdateError,
        listener: (ctx, state) {
          if (state is BranchCreated || state is BranchUpdated) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(_isEdit
                    ? 'Branch updated successfully'
                    : 'Branch created successfully'),
                backgroundColor: const Color(0xFF10B981),
              ),
            );
            Navigator.pop(ctx, true);
          } else if (state is BranchCreateError) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          } else if (state is BranchUpdateError) {
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
                  _Open24Toggle(
                    value: _isOpen24Hours,
                    onChanged: (v) => setState(() {
                      _isOpen24Hours = v;
                      if (v) {
                        _openingTime = null;
                        _closingTime = null;
                      }
                    }),
                  ),
                  if (!_isOpen24Hours) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _TimePicker(
                            label: 'Opening Time',
                            value: _openingTime,
                            onPicked: (t) => setState(() => _openingTime = t),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _TimePicker(
                            label: 'Closing Time',
                            value: _closingTime,
                            onPicked: (t) => setState(() => _closingTime = t),
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
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                ]),
                const SizedBox(height: 12),
                _FormCard(children: [
                  const _SectionTitle('Status'),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: _dropdownDecoration(),
                    items: const [
                      DropdownMenuItem(value: 'ACTIVE', child: Text('Active')),
                      DropdownMenuItem(value: 'INACTIVE', child: Text('Inactive')),
                    ],
                    onChanged: (v) => setState(() => _status = v ?? 'ACTIVE'),
                  ),
                ]),
                const SizedBox(height: 24),
                BlocBuilder<BranchesBloc, BranchesState>(
                  builder: (context, state) {
                    final isLoading =
                        state is BranchCreating || state is BranchUpdating;
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
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : Text(
                                _isEdit ? 'Save Changes' : 'Create Branch',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
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

    if (!_isOpen24Hours) {
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
    }

    if (_isEdit) {
      context.read<BranchesBloc>().add(
            SubmitUpdateBranch(
              UpdateBranchParams(
                branchId:      widget.existing!.branchId,
                name:          _nameCtrl.text.trim(),
                city:          _cityCtrl.text.trim(),
                phone:         _phoneCtrl.text.trim(),
                email:         _emailCtrl.text.trim(),
                address:       _addressCtrl.text.trim(),
                openingTime:   _isOpen24Hours ? null : _openingTime,
                closingTime:   _isOpen24Hours ? null : _closingTime,
                isOpen24Hours: _isOpen24Hours,
                status:        _status,
              ),
            ),
          );
    } else {
      context.read<BranchesBloc>().add(
            SubmitCreateBranch(
              CreateBranchParams(
                name:          _nameCtrl.text.trim(),
                city:          _cityCtrl.text.trim(),
                phone:         _phoneCtrl.text.trim(),
                email:         _emailCtrl.text.trim(),
                address:       _addressCtrl.text.trim(),
                openingTime:   _isOpen24Hours ? null : _openingTime,
                closingTime:   _isOpen24Hours ? null : _closingTime,
                isOpen24Hours: _isOpen24Hours,
                status:        _status,
              ),
            ),
          );
    }
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

class _Open24Toggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _Open24Toggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: value ? const Color(0xFFEFF6FF) : const Color(0xFFF9FAFB),
          border: Border.all(
            color: value ? const Color(0xFF3B82F6) : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              Icons.wb_sunny_outlined,
              size: 18,
              color: value ? const Color(0xFF2563EB) : Colors.grey.shade500,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Open 24 Hours',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: value
                      ? const Color(0xFF1D4ED8)
                      : const Color(0xFF374151),
                ),
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF2563EB),
            ),
          ],
        ),
      ),
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
