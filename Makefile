APPS = Main ClockWeather MusicPlayer SystemStatus Todo Calendar Dock Apps Bar

.PHONY: run-all

run:
	qml6 Main.qml

run-cw:
	qml6 ClockWeather.qml

run-music:
	qml6 MusicPlayer.qml

run-status:
	qml6 SystemStatus.qml

run-todo:
	qml6 Todo.qml

run-calendar:
	qml6 Calendar.qml

run-dock:
	qml6 Dock.qml

run-apps:
	qml6 Apps.qml

run-bar:
	qml6 Bar.qml

run-all:
	@trap 'trap - INT TERM; kill 0' INT TERM; \
	for app in $(APPS); do qml6 $$app.qml & done; \
	wait
