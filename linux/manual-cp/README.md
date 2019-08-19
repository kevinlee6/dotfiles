Need to manual copy / paste and adjust some arguments due to it being absolute
path.

## i3lock-before-sleep.service
1. Copy / modify to /etc/systemd/system/i3lock-before-sleep.service
2. sudo systemctl enable i3lock-before-sleep.service
3. sudo systemctl daemon-reload
4. test: systemctl.suspend
reference link: https://forum.manjaro.org/t/how-to-fix-lock-screen-after-changing-gdm-to-lightdm/62751/42
