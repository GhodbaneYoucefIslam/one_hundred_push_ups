const { get } = require("https");

function getPreviousDate() {
  const currentDate = new Date(); // Get current date
  const oneDay = 24 * 60 * 60 * 1000; // Number of milliseconds in a day
  const previousDate = new Date(currentDate.getTime() - oneDay); // Subtract one day
  return previousDate.getFullYear()+"-"+(previousDate.getMonth()+1).toString().padStart(2,"0")+"-"+previousDate.getDate()+"T00:00:00Z"; // Format as YYYY-MM-DD
}
const previousDate = getPreviousDate();
const achievements = [
  {
    "type": "pushups",
    "score": 100,
    "day": previousDate,
    "dailyRank": 9,
    "rankChange": null,
    "userId": 1
  },
  {
    "type": "pushups",
    "score": 150,
    "day": previousDate,
    "dailyRank": 4,
    "rankChange": null,
    "userId": 2
  },
  {
    "type": "pushups",
    "score": 120,
    "day": previousDate,
    "dailyRank": 7,
    "rankChange": null,
    "userId": 3
  },
  {
    "type": "pushups",
    "score": 130,
    "day": previousDate,
    "dailyRank": 6,
    "rankChange": null,
    "userId": 4
  },
  {
    "type": "pushups",
    "score": 110,
    "day": previousDate,
    "dailyRank": 8,
    "rankChange": null,
    "userId": 5
  },
  {
    "type": "pushups",
    "score": 140,
    "day": previousDate,
    "dailyRank": 5,
    "rankChange": null,
    "userId": 6
  },
  {
    "type": "pushups",
    "score": 170,
    "day": previousDate,
    "dailyRank": 2,
    "rankChange": null,
    "userId": 7
  },
  {
    "type": "pushups",
    "score": 90,
    "day": previousDate,
    "dailyRank": 10,
    "rankChange": null,
    "userId": 8
  },
  {
    "type": "pushups",
    "score": 160,
    "day": previousDate,
    "dailyRank": 3,
    "rankChange": null,
    "userId": 9
  },
  {
    "type": "pushups",
    "score": 180,
    "day": previousDate,
    "dailyRank": 1,
    "rankChange": null,
    "userId": 10
  }
]

module.exports = achievements  