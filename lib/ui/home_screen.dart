import 'package:flutter/material.dart';
import 'package:flutter_cep/models/cep_model.dart';
import 'package:flutter_cep/repositories/cep_repository.dart';
import 'package:flutter_cep/ui/widgets/address_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final repository = CepRepository(client: http.Client());
  final cepController = TextEditingController();
  final cepFormatter = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {'#': RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  String? errorMessage;
  CepModel? cepModel;
  bool isLoading = false;

  Future<void> buscarCep() async {
    FocusScope.of(context).unfocus();
    setState(() {
      errorMessage = null;
      cepModel = null;
      isLoading = true;
    });

    final cep = cepController.text.trim();

    if (cep.isEmpty) {
      setState(() {
        errorMessage = 'Digite um CEP válido';
        isLoading = false;
      });
      return;
    }

    try {
      final addressModel = await repository.consultarCep(cep);
      setState(() {
        errorMessage = null;
        cepModel = addressModel;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'CEP não encontrado';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    cepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta de CEP'),
        leading: Icon(Icons.location_city),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.1),
                    theme.colorScheme.secondary.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.search_rounded,
                    size: 48,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Busque por qualquer CEP',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Digite o CEP e descubra o endereço completo',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: cepController,
              keyboardType: TextInputType.number,
              maxLength: 9,
              inputFormatters: [cepFormatter],
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.location_on_rounded),
                labelText: 'CEP',
                hintText: 'Digite o CEP (ex: 01310-200)',
                counterText: '',
              ),
            ),
            SizedBox(height: 12),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: isLoading
                  ? Container(
                      key: ValueKey('loading'),
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Buscando CEP...',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ElevatedButton.icon(
                      key: ValueKey('button'),
                      onPressed: buscarCep,
                      icon: Icon(Icons.search_rounded),
                      label: Text('Buscar CEP'),
                    ),
            ),
            SizedBox(height: 12),
            if (errorMessage != null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: theme.colorScheme.error,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        errorMessage!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (cepModel != null)
              AnimatedOpacity(
                opacity: cepModel != null ? 1.0 : 0.0,
                duration: Duration(milliseconds: 1000),
                child: AddressWidgets(
                  cepModel: cepModel!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}