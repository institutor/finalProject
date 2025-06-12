class ScoreEntry implements Comparable<ScoreEntry> { // I MADE THIS B/C I WANTED TO KEEP TRACK OF PLAYER SCORES ACROSS GAMES
  private String name;
  private int score;

  ScoreEntry(String name, int score) {
    this.name = name;
    this.score = score;
  }

  public int compareTo(ScoreEntry other) {
    return other.score - this.score;
  }
}
