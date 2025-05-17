#!/bin/bash

if [ ! -d "inputs" ]; then
  mkdir inputs
  echo "inputs directory created"
fi
if [ ! -d "mid" ]; then
  mkdir mid
  echo "mid directory created"
fi
if [ ! -d "outputs" ]; then
  mkdir outputs
  echo "outputs directory created"
fi

# Convert mp3 to wav
echo "---start converting mp3 to wav---"
ffmpeg -i /home/leo/Desktop/leo-ext/self/other/fish-speech/self/inputs/input.mp3 mid/input.wav -y
echo "---end converting mp3 to wav---"

src_audio="/home/leo/Desktop/leo-ext/self/other/fish-speech/self/mid/input.wav"

# Extract audio features
echo "---start extracting audio features---"
python /home/leo/Desktop/leo-ext/self/other/fish-speech/fish_speech/models/vqgan/inference.py \
    -i "$src_audio" \
    -o /home/leo/Desktop/leo-ext/self/other/fish-speech/self/outputs/fake.wav \
    --checkpoint-path "/home/leo/Desktop/leo-ext/self/other/fish-speech/checkpoints/fish-speech-1.5/firefly-gan-vq-fsq-8x1024-21hz-generator.pth"
echo "---end extracting audio features---"

# Generate audio features
echo "---start generating audio features---"
python /home/leo/Desktop/leo-ext/self/other/fish-speech/fish_speech/models/text2semantic/inference.py \
    --text "heloo guys nice to meet you am hello world, i am the admin of spectral" \
    --prompt-text "The text corresponding to reference audio" \
    --prompt-tokens "/home/leo/Desktop/leo-ext/self/other/fish-speech/self/outputs/fake.npy" \
    --checkpoint-path "/home/leo/Desktop/leo-ext/self/other/fish-speech/checkpoints/fish-speech-1.5" \
    --num-samples 2 \
    --compile
echo "---end generating audio features---"

# Generate audio
echo "---start generating audio---"
python /home/leo/Desktop/leo-ext/self/other/fish-speech/fish_speech/models/vqgan/inference.py \
    -i "/home/leo/Desktop/leo-ext/self/other/fish-speech/self/temp/codes_0.npy" \
    -o /home/leo/Desktop/leo-ext/self/other/fish-speech/self/outputs/new.wav \
    --checkpoint-path "/home/leo/Desktop/leo-ext/self/other/fish-speech/checkpoints/fish-speech-1.5/firefly-gan-vq-fsq-8x1024-21hz-generator.pth"
echo "---end generating audio---"

# Convert wav to mp3
echo "---start converting wav to mp3---"
ffmpeg -i /home/leo/Desktop/leo-ext/self/other/fish-speech/self/outputs/new.wav /home/leo/Desktop/leo-ext/self/other/fish-speech/self/outputs/new.mp3 -y
echo "---end converting wav to mp3---"