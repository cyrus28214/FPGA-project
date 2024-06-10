import mido

# 获得每四分音符的微秒数
def get_tempo_from_track(track):
    for msg in track:
        if msg.type == 'set_tempo':
            return msg.tempo
    return 500000  # 如果未找到 tempo 事件，则默认使用 120 BPM 对应的微秒数

def ticks_to_seconds(ticks, ticks_per_beat, tempo):
    return ticks * (tempo / 1_000_000) / ticks_per_beat


def parse_midi(file_path):
    midi = mido.MidiFile(file_path)
    notes = []

    ticks_per_beat = midi.ticks_per_beat

    for track in midi.tracks:
        tempo = get_tempo_from_track(track)
        absolute_time = 0
        for msg in track:
            absolute_time += msg.time

            if msg.type == 'note_on' and msg.velocity > 0:
                start_time = absolute_time
                note = msg.note
            elif msg.type == 'note_off' or (msg.type == 'note_on' and msg.velocity == 0):
                end_time = absolute_time
                duration = end_time - start_time
                notes.append((note, int(1000 * ticks_to_seconds(start_time, ticks_per_beat, tempo)), int(1000 * ticks_to_seconds(duration, ticks_per_beat, tempo))))

    return notes

# 替换 'your_midi_file.mid' 为你的 MIDI 文件路径
midi_file_path = "./resources/music/bgm.mid"
notes_durations = parse_midi(midi_file_path)
p = 0

note = []
pos = []
for noted, start, duration in notes_durations:
    if start != p:
        print(f"Note: 0, Start: {p}, Duration: {start - p}")
        p = start
        note.append(0)
        pos.append(p)
    print(f"Note: {noted}, Start: {start}, Duration: {duration}")
    p += duration
    note.append(noted)
    pos.append(p)

print(f"parameter MAXN = {len(note)};")

print("reg [31:0] pos[MAXN-1:0];")
print("reg [7:0] note[MAXN-1:0];")

print("initial begin")
for i in range(len(note)):
    print(f"    note[{i}] = {note[i]};")
print("end")

print("initial begin")
for i in range(len(note)):
    print(f"    pos[{i}] = {pos[i]};")
print("end")