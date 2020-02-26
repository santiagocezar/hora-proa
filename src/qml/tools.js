function minutesToTime(minutes) {
    return ("0" + Math.floor(minutes / 60)).slice(-2) + ":" + ("0" + minutes % 60).slice(-2)
}
