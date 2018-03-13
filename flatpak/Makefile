APP_DIR=app-dir
MANIFEST=org.flatpak.Hello.json
EXECUTABLE=hello.sh

.phony: clean

clean:
	rm -Rf $(APP_DIR)

pack: clean
	flatpak-builder $(APP_DIR) $(MANIFEST)

test:
	flatpak-builder --run $(APP-DIR) $(MANIFEST) $(EXECUTABLE)

