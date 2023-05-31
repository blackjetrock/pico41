sudo kill `pgrep openocd`
sudo openocd -f interface/picoprobe.cfg -f target/rp2040.cfg -c "program /tree/projects/github/hp41c/pico41/code/pico41/build/pico41.elf verify reset exit"
