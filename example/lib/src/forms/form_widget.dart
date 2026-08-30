import 'package:flutter/cupertino.dart';
import 'package:material_ui/material_ui.dart';

class FormWidget extends StatelessWidget {
  const FormWidget({super.key, required this.label, required this.child});
  final String label;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: <Widget>[
          Text(label, style: const TextStyle(fontSize: 14.0)),
          Expanded(
            child: Align(alignment: Alignment.centerRight, child: child),
          ),
        ],
      ),
    );
  }
}

class FormSelect<T> extends StatefulWidget {
  const FormSelect({
    super.key,
    required this.placeholder,
    required this.valueChanged,
    required this.value,
    required this.values,
  });
  final String placeholder;
  final ValueChanged<T> valueChanged;
  final List<T> values;
  final T value;

  @override
  State<StatefulWidget> createState() {
    return _FormSelectState<T>();
  }
}

class _FormSelectState<T> extends State<FormSelect<T>> {
  int _selectedIndex = 0;

  @override
  void initState() {
    for (var i = 0; i < widget.values.length; ++i) {
      if (widget.values[i] == widget.value) {
        _selectedIndex = i;
        break;
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final placeholder = widget.placeholder;
    final values = widget.values;

    return InkWell(
      child: Text(
        _selectedIndex < 0 ? placeholder : values[_selectedIndex].toString(),
      ),
      onTap: () {
        _selectedIndex = 0;
        showBottomSheet(
          context: context,
          builder: (context) {
            return SizedBox(
              height: values.length * 30.0 + 200.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: values.length * 30.0 + 70.0,
                    child: CupertinoPicker(
                      itemExtent: 30.0,
                      children: values.map((value) {
                        return Text(value.toString());
                      }).toList(),
                      onSelectedItemChanged: (index) {
                        _selectedIndex = index;
                      },
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedIndex >= 0) {
                          widget.valueChanged(widget.values[_selectedIndex]);
                        }

                        setState(() {});

                        Navigator.of(context).pop();
                      },
                      child: const Text('ok'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class NumberPad extends StatelessWidget {
  const NumberPad({
    super.key,
    required this.number,
    required this.step,
    required this.onChangeValue,
    required this.max,
    required this.min,
  });
  final num number;
  final num step;
  final num max;
  final num min;
  final ValueChanged<num> onChangeValue;

  void onAdd() {
    onChangeValue(number + step > max ? max : number + step);
  }

  void onSub() {
    onChangeValue(number - step < min ? min : number - step);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(icon: const Icon(Icons.exposure_neg_1), onPressed: onSub),
        Text(
          number is int ? number.toString() : number.toStringAsFixed(1),
          style: const TextStyle(fontSize: 14.0),
        ),
        IconButton(icon: const Icon(Icons.exposure_plus_1), onPressed: onAdd),
      ],
    );
  }
}
