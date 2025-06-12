import java.util.Collections;
class Leaderboard { // I MADE THIS B/C I WANTED TO KEEP TRACK OF PLAYER SCORES ACROSS GAMES
  private ArrayList<ScoreEntry> entries;
  private String filename;
  private final int MAX_ENTRIES = 5;

  Leaderboard(String filename) {
    this.filename = filename;
    this.entries = new ArrayList<ScoreEntry>();
    loadScores();
  }

  void loadScores() {
    try {
      String[] lines = loadStrings(filename);
      for (String line : lines) {
        String[] parts = line.split(",");
        if (parts.length == 2) {
          entries.add(new ScoreEntry(parts[0], Integer.parseInt(parts[1])));
        }
      }
    } 
    catch (Exception e) {
      println("Error has occurred");
    }
  }

  void saveScores() {
    String[] lines = new String[entries.size()];
    for (int i = 0; i < entries.size(); i++) {
      ScoreEntry e = entries.get(i);
      lines[i] = e.name + "," + e.score;
    }
    saveStrings(filename, lines);
  }

  void addScore(String name, int score) {
    entries.add(new ScoreEntry(name, score));
    Collections.sort(entries);
    while (entries.size() > MAX_ENTRIES) {
      entries.remove(entries.size() - 1);
    }
    saveScores();
  }
  ArrayList<ScoreEntry> getEntries() {
    return entries;
  }
}
