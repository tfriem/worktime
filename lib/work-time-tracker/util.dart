String formatDuration(Duration duration) =>
    '${duration.inHours.toString().padLeft(2,'0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
