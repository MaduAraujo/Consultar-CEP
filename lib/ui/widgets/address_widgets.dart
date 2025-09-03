import 'package:flutter/material.dart';
import 'package:flutter_cep/models/cep_model.dart';

class AddressWidgets extends StatefulWidget {
  final CepModel? cepModel;

  const AddressWidgets({super.key, this.cepModel});

  @override
  State<AddressWidgets> createState() => _AddressWidgetsState();
}

class _AddressWidgetsState extends State<AddressWidgets> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.cepModel == null) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 48,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'CEP Encontrado!',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              Text(
                'Informações do Endereço',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white.withAlpha(229),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 12,
        ),
        _InfoCard(
          icon: Icons.location_on_rounded,
          title: 'CEP',
          subtitle: widget.cepModel!.cep,
          color: theme.colorScheme.primary,
        ),
        _InfoCard(
          icon: Icons.streetview_rounded,
          title: 'Logradouro',
          subtitle: widget.cepModel!.logradouro,
          color: theme.colorScheme.secondary,
        ),
        _InfoCard(
          icon: Icons.home_rounded,
          title: 'Bairro',
          subtitle: widget.cepModel!.bairro,
          color: theme.colorScheme.tertiary,
        ),
        _InfoCard(
          icon: Icons.location_city_rounded,
          title: 'Cidade',
          subtitle: widget.cepModel!.localidade,
          color: Colors.green,
        ),
        _InfoCard(
          icon: Icons.map_rounded,
          title: 'Estado',
          subtitle: widget.cepModel!.uf,
          color: Colors.orange,
        ),
        if (widget.cepModel!.complemento.isNotEmpty)
          _InfoCard(
            icon: Icons.info_rounded,
            title: 'Complemento',
            subtitle: widget.cepModel!.complemento,
            color: Colors.purple,
          ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: color.withAlpha(51),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}