import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/evento_calendario.dart';
import '../../providers/calendario_provider.dart';
import '../../providers/turma_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/section_card.dart';

/// Réplica da tela "Calendário" do protótipo: grade mensal com bolinhas
/// coloridas nos dias com eventos, lista de eventos do dia selecionado e
/// formulário para atribuir um novo trabalho/prova a uma turma e data.
class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  DateTime _mesAtual = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _diaSelecionado = DateTime.now();
  String? _turmaSelecionada;
  TipoEvento _tipoSelecionado = TipoEvento.trabalho;
  final _tituloCtrl = TextEditingController();

  static const _diasSemana = ['Do', 'Se', 'Te', 'Qa', 'Qi', 'Se', 'Sa'];

  void _mudarMes(int delta) {
    setState(() => _mesAtual = DateTime(_mesAtual.year, _mesAtual.month + delta));
  }

  Color _corEvento(TipoEvento tipo) {
    switch (tipo) {
      case TipoEvento.aula:
        return AppColors.primaryBlue;
      case TipoEvento.trabalho:
        return AppColors.accentYellow;
      case TipoEvento.prova:
        return AppColors.statusRed;
    }
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (_turmaSelecionada == null || _tituloCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha o título e selecione a turma.')),
      );
      return;
    }
    await Provider.of<CalendarioProvider>(context, listen: false).adicionarEvento(
      titulo: _tituloCtrl.text.trim(),
      data: _diaSelecionado,
      turma: _turmaSelecionada!,
      tipo: _tipoSelecionado,
    );
    if (mounted) {
      _tituloCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Evento cadastrado no calendário!'),
          backgroundColor: AppColors.statusGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final calProv = Provider.of<CalendarioProvider>(context);
    final turmaProv = Provider.of<TurmaProvider>(context);

    final primeiroDia = DateTime(_mesAtual.year, _mesAtual.month, 1);
    final diasNoMes = DateTime(_mesAtual.year, _mesAtual.month + 1, 0).day;
    final offset = primeiroDia.weekday % 7;

    return Scaffold(
      appBar: AppBar(title: const Text('Calendário')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () => _mudarMes(-1),
                    ),
                    Text(
                      '${_nomeMes(_mesAtual.month)} ${_mesAtual.year}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () => _mudarMes(1),
                    ),
                  ],
                ),
                GridView.count(
                  crossAxisCount: 7,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (final d in _diasSemana)
                      Center(
                        child: Text(d,
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      ),
                    for (var i = 0; i < offset; i++) const SizedBox.shrink(),
                    for (var d = 1; d <= diasNoMes; d++)
                      _DiaCell(
                        dia: d,
                        selecionado: _diaSelecionado.year == _mesAtual.year &&
                            _diaSelecionado.month == _mesAtual.month &&
                            _diaSelecionado.day == d,
                        eventos: calProv.eventosDoDia(DateTime(_mesAtual.year, _mesAtual.month, d)),
                        corEvento: _corEvento,
                        onTap: () => setState(
                          () => _diaSelecionado = DateTime(_mesAtual.year, _mesAtual.month, d),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: 'Eventos do dia ${_diaSelecionado.day.toString().padLeft(2, '0')}/'
                '${_diaSelecionado.month.toString().padLeft(2, '0')}',
            child: calProv.eventosDoDia(_diaSelecionado).isEmpty
                ? const Text('Nenhum evento neste dia.', style: TextStyle(color: AppColors.textMuted))
                : Column(
                    children: calProv
                        .eventosDoDia(_diaSelecionado)
                        .map(
                          (e) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(radius: 6, backgroundColor: _corEvento(e.tipo)),
                            title: Text(e.titulo),
                            subtitle: Text('${e.tipo.label} • Turma ${e.turma}'),
                          ),
                        )
                        .toList(),
                  ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: 'Atribuição de trabalhos/provas',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _tituloCtrl,
                  decoration: const InputDecoration(labelText: 'Título do evento'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _turmaSelecionada,
                  decoration: const InputDecoration(labelText: 'Selecione a turma'),
                  items: turmaProv.turmas
                      .map((t) => DropdownMenuItem(value: t.nome, child: Text(t.nome)))
                      .toList(),
                  onChanged: (v) => setState(() => _turmaSelecionada = v),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<TipoEvento>(
                  value: _tipoSelecionado,
                  decoration: const InputDecoration(labelText: 'Tipo de evento'),
                  items: TipoEvento.values
                      .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                      .toList(),
                  onChanged: (v) => setState(() => _tipoSelecionado = v ?? TipoEvento.trabalho),
                ),
                const SizedBox(height: 8),
                Text(
                  'Data selecionada: ${_diaSelecionado.day.toString().padLeft(2, '0')}/'
                  '${_diaSelecionado.month.toString().padLeft(2, '0')}/${_diaSelecionado.year}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: _cadastrar, child: const Text('CADASTRAR')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _nomeMes(int m) {
    const nomes = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
    ];
    return nomes[m - 1];
  }
}

class _DiaCell extends StatelessWidget {
  final int dia;
  final bool selecionado;
  final List<EventoCalendario> eventos;
  final Color Function(TipoEvento) corEvento;
  final VoidCallback onTap;

  const _DiaCell({
    required this.dia,
    required this.selecionado,
    required this.eventos,
    required this.corEvento,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: selecionado ? AppColors.primaryBlue : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$dia',
              style: TextStyle(
                fontSize: 12,
                color: selecionado ? Colors.white : AppColors.textDark,
                fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (eventos.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Wrap(
                  spacing: 2,
                  children: eventos
                      .take(3)
                      .map(
                        (e) => Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selecionado ? Colors.white : corEvento(e.tipo),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
