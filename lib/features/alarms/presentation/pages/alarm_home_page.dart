import 'package:alarm_app/constants/app_colors.dart';
import 'package:alarm_app/helpers/snackbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/alarm_bloc.dart';
import '../bloc/alarm_event.dart';
import '../bloc/alarm_state.dart';

class AlarmHomePage extends StatelessWidget {
  const AlarmHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AlarmBloc>()
        ..add(LoadAlarmsEvent())
        ..add(LoadUserLocationEvent()),
      child: const _AlarmHomePageContent(),
    );
  }
}

class _AlarmHomePageContent extends StatelessWidget {
  const _AlarmHomePageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 5),
        child: FloatingActionButton(
          onPressed: () => _showTimePicker(context),
          shape: const CircleBorder(),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add, size: 30),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        child: BlocConsumer<AlarmBloc, AlarmState>(
          listener: (context, state) {
            if (state is AlarmError) {
              SnackBarHelper.showError(context, state.message);
            } else if (state is AlarmDeleted) {
              SnackBarHelper.showSuccess(
                context,
                '${state.time} alarm dismissed',
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.10),

                    // Location Section
                    _buildLocationSection(context, state),

                    const SizedBox(height: 20),

                    // Alarms Section
                    const Text(
                      'Alarms',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    const SizedBox(height: 10),

                    // Alarms List
                    Expanded(child: _buildAlarmsList(context, state)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context, AlarmState state) {
    final location = state is AlarmLoaded
        ? state.userLocation ?? 'Add your location'
        : 'Add your location';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Selected Location",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(69),
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          child: Row(
            children: [
              Icon(Icons.location_on_outlined, color: Colors.grey[300]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(
                    color: Color.fromARGB(146, 201, 201, 201),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildAlarmsList(BuildContext context, AlarmState state) {
    if (state is AlarmLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (state is AlarmLoaded) {
      if (state.alarms.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.alarm_off,
                size: 80,
                color: Colors.white.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No alarms set',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap + to add an alarm',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: state.alarms.length,
        itemBuilder: (context, index) {
          final alarm = state.alarms[index];
          return _buildAlarmItem(context, alarm);
        },
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildAlarmItem(BuildContext context, alarm) {
    return Dismissible(
      key: Key(alarm.id.toString()),
      onDismissed: (direction) {
        context.read<AlarmBloc>().add(DeleteAlarmEvent(alarm.id));
      },
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red[400],
          borderRadius: BorderRadius.circular(69),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(75, 66, 66, 66),
          borderRadius: BorderRadius.circular(69),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      alarm.time,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      alarm.date,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(110, 255, 255, 255),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CupertinoSwitch(
              value: alarm.isActive,
              onChanged: (val) {
                context.read<AlarmBloc>().add(ToggleAlarmEvent(alarm.id, val));
              },
              inactiveTrackColor: Colors.white,
              activeTrackColor: Theme.of(context).colorScheme.primary,
              inactiveThumbColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && context.mounted) {
      context.read<AlarmBloc>().add(AddAlarmEvent(picked));
    }
  }
}
