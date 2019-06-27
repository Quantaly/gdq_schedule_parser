// With reference to RFC 2445, section 4.3.6
const durValue = "(?:\\+?|-)P(?:$durDate|$durTime|$durWeek)";

const durDate = "$durDay(?:$durTime)?";
const durTime = "T(?:$durHour|$durMinute|$durSecond)";
const durWeek = "\\d+W";
const durHour = "\\d+H(?:$durMinute)?";
const durMinute = "\\d+M(?:$durSecond)?";
const durSecond = "\\d+S";
const durDay = "\\d+D";
