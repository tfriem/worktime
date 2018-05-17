import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

import '../app/model.dart';
import '../core/date.dart';
import 'actions.dart';
import 'model.dart';

class BookingDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BookingDetailViewModel>(
      converter: (Store<AppState> store) {
        final selectedDate = store.state.workTimeTracker.selectedDate;
        return BookingDetailViewModel(
            selectedDate,
            store.state.workTimeTracker.bookings[selectedDate],
            (newTime) =>
                store.dispatch(WorkTimeChangeStartTime(selectedDate, newTime)),
            (newTime) =>
                store.dispatch(WorkTimeChangeEndTime(selectedDate, newTime)));
      },
      builder: (BuildContext context, BookingDetailViewModel vm) {
        TimeOfDay starTime;
        TimeOfDay endTime;
        if (vm.booking?.start != null) {
          starTime = TimeOfDay.fromDateTime(vm.booking.start);
        }
        if (vm.booking?.end != null) {
          endTime = TimeOfDay.fromDateTime(vm.booking.end);
        }
        return new Column(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                  DateFormat("yMMMMEEEEd").format(vm.selectedDay.toDateTime()),
                  style: Theme.of(context).textTheme.subhead),
            ),
            _buildTimeSelector(starTime, TimeOfDay(hour: 8, minute: 0), "Start",
                vm.changeStartTime, context),
            _buildTimeSelector(endTime, TimeOfDay(hour: 17, minute: 0), "End",
                vm.changeEndTime, context)
          ],
        );
      },
    );
  }

  Widget _buildTimeSelector(
      TimeOfDay displayTime,
      TimeOfDay fallbackTime,
      String fallbackText,
      void Function(TimeOfDay newTime) callback,
      BuildContext context) {
    String displayText = fallbackText;
    TimeOfDay initialTime = fallbackTime;
    if (displayTime != null) {
      displayText = displayTime.format(context);
      initialTime = displayTime;
    }
    return new Card(
      child: new Padding(
        padding: new EdgeInsets.all(12.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Expanded(
                child: new Text(displayText,
                    style: Theme.of(context).primaryTextTheme.subhead)),
            new IconButton(
              icon: new Icon(Icons.edit),
              onPressed: onEditButtonPressed(context, initialTime, callback),
            ),
            new IconButton(
              icon: new Icon(Icons.delete_forever),
              onPressed: onDeleteButtonPressed(callback),
            ),
          ],
        ),
      ),
    );
  }

  onEditButtonPressed(BuildContext context, TimeOfDay initialTime,
      void changeTime(TimeOfDay time)) {
    return () {
      showTimePicker(context: context, initialTime: initialTime)
          .then((time) => changeTime(time));
    };
  }

  onDeleteButtonPressed(void changeTime(TimeOfDay time)) {
    return () {
      changeTime(null);
    };
  }
}

@immutable
class BookingDetailViewModel {
  final Date selectedDay;
  final Booking booking;
  final void Function(TimeOfDay newTime) changeStartTime;
  final void Function(TimeOfDay newTime) changeEndTime;

  BookingDetailViewModel(
      this.selectedDay, this.booking, this.changeStartTime, this.changeEndTime);
}