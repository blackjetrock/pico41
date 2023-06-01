sudo kill `pgrep openocd`
sudo openocd -f interface/picoprobe.cfg -f target/rp2040.cfg -c "program /tree/projects/github/pico41/firmware/build/pico41.elf verify reset exit"
