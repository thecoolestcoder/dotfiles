import json
import subprocess
import sys

def get_media_info():
    try:
        title = subprocess.check_output(["playerctl", "metadata", "xesam:title"], stderr=subprocess.DEVNULL).decode("utf-8").strip()
        artist = subprocess.check_output(["playerctl", "metadata", "xesam:artist"], stderr=subprocess.DEVNULL).decode("utf-8").strip()
        player_name = subprocess.check_output(["playerctl", "-l"], stderr=subprocess.DEVNULL).decode("utf-8").split('.')[0].strip()
        status = subprocess.check_output(["playerctl", "status"], stderr=subprocess.DEVNULL).decode("utf-8").strip()

        # Tooltip content
        tooltip = f"Song: {title}\nArtist: {artist}\nSource: {player_name}\nStatus: {status}"

        return json.dumps({
            "text": title[:30],
            "tooltip": tooltip,
            "class": status.lower()
        })
    except:
        return json.dumps({"text": "Media", "tooltip": "No media playing"})
if __name__ == "__main__":
    sys.stdout.reconfigure(encoding='utf-8')
    print(get_media_info())
