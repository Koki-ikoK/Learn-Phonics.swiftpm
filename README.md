<p align="center">
  <img src="https://github.com/user-attachments/assets/9b579dce-236d-4275-9371-0ee64d0bc956" width="31%" alt="シミュレータ画面1">
  <img src="https://github.com/user-attachments/assets/c1e16446-2c87-429e-9cbd-7dc3416ab5a6" width="31%" alt="シミュレータ画面2" style="margin-left: 8px; margin-right: 8px;">
  <img src="https://github.com/user-attachments/assets/abbcdd64-ba43-46a2-93f4-121094e69b43" width="31%" alt="シミュレータ画面3">
</p>
# Learn Phonics 🗣️ (Swift Playgrounds Project)

### 概要
英語の正しい発音の基礎となる「フォニックス」を、インタラクティブに学習するためのiPad/Mac向けアプリケーションです。

### 開発背景
現在、TOEIC 800点を目指して英語学習に励んでいますが、単語のスペルと音の関係（フォニックス）を正しく理解することが、リスニング・スピーキング力向上の最短ルートだと感じました。
自身の学習体験をベースに、初心者でも遊びながら発音のルールを学べるツールとして作成しました。
また、アメリカに旅行に行った先に、フォニックスを日本では重視していないと話したところ、フォニックスをすることを推奨されたこと、現地の子供と発音が伝わらずスムーズに会話ができなかったこと。
この2点がフォニックスのアプリを作ろうと思い始めたきっかけです。

### 主な機能
- 発音ガイド: `AVFoundation` を活用し、ネイティブに近い発音を確認できる機能。
- インタラクティブ・クイズ: 提示された音に対して正しいスペルを選択する学習ゲーム。
- 直感的なUI: Swift Playgroundsならではの、コードとUIが連動した学習体験。

### 使用技術
- Environment: Swift Playgrounds
- Language: Swift
- Framework: SwiftUI, AVFoundation

### 今後の展望
- 音声認識機能を追加し、ユーザーの発音をリアルタイムでフィードバックする機能の実装。
- 学習進捗を可視化するダッシュボードの構築。
