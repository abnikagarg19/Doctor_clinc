import 'dart:typed_data';
import 'dart:convert';
import 'dart:html' as html;

class WavAudioPlayer {
  String? _url;
  html.AudioElement? _audio;

  /// Play raw PCM16 audio data
  /// [gain] is amplification factor, e.g. 1.0 = normal, 2.0 = double loudness
  void play(Uint8List pcmData, {int sampleRate = 16000, int channels = 1, double gain = 1.0}) {
    final amplifiedPcm = _applyGain(pcmData, gain);
    final wavData = _pcmToWav(amplifiedPcm, sampleRate: sampleRate, channels: channels);

    final blob = html.Blob([wavData]);
    _url = html.Url.createObjectUrlFromBlob(blob);

    _audio = html.AudioElement(_url!)
      ..controls = false
      ..autoplay = true;

    _audio!.play().catchError((e) {
      print("⚠️ autoplay blocked: $e");
    });
  }

  /// Apply gain (volume boost/reduction) to PCM16 data
  Uint8List _applyGain(Uint8List pcm, double gain) {
    final buffer = pcm.buffer.asInt16List(pcm.offsetInBytes, pcm.lengthInBytes ~/ 2);
    final amplified = Int16List(buffer.length);

    for (int i = 0; i < buffer.length; i++) {
      int val = (buffer[i] * gain).round();
      // Clamp to valid PCM16 range
      if (val > 32767) val = 32767;
      if (val < -32768) val = -32768;
      amplified[i] = val;
    }

    return amplified.buffer.asUint8List();
  }

  /// Convert PCM16 → WAV
  Uint8List _pcmToWav(Uint8List pcm, {int sampleRate = 16000, int channels = 1}) {
    int byteRate = sampleRate * channels * 2;
    int blockAlign = channels * 2;
    int dataLength = pcm.length;
    int fileSize = 36 + dataLength;

    final header = BytesBuilder();
    header.add(ascii.encode('RIFF'));
    header.add(_intToBytes(fileSize, 4));
    header.add(ascii.encode('WAVE'));
    header.add(ascii.encode('fmt '));
    header.add(_intToBytes(16, 4)); // PCM chunk size
    header.add(_intToBytes(1, 2));  // Audio format = PCM
    header.add(_intToBytes(channels, 2));
    header.add(_intToBytes(sampleRate, 4));
    header.add(_intToBytes(byteRate, 4));
    header.add(_intToBytes(blockAlign, 2));
    header.add(_intToBytes(16, 2)); // Bits per sample
    header.add(ascii.encode('data'));
    header.add(_intToBytes(dataLength, 4));

    return Uint8List.fromList(header.toBytes() + pcm);
  }

  List<int> _intToBytes(int value, int byteCount) {
    final bytes = <int>[];
    for (int i = 0; i < byteCount; i++) {
      bytes.add((value >> (8 * i)) & 0xFF);
    }
    return bytes;
  }
}
