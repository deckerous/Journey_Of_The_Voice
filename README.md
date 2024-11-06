# Journey_Of_The_Voice
 **Source Code Access:**
 - No special resources excluded from the repo, just clone repo onto your machine.

 **Directory Layout:**
 - .github/workflows: Contains .yml files for running our CI setup for Godot using Github Acctions.
 - Audio: Contains music for the project in .mp3 files.
 - Chapters: contains the content for the game using generic components which includes Chapters, areas, conversations, characters, and .json files for the conversations.
 - Characters: Contains character scenes and art assets.
 - Generic Components: Contains base chapter, area, conversation, and character scenes and scripts.
 - UI: Contains UI scenes, scripts, and assets for menus and UI elements.
 - addons/gut: Contains the GUT plugin for unit testing in Godot. Leave it unchanged in the main directory.
 - tests/unit: Contains written unit tests for the game that are run on commit to the repo.

**How to Build the Sofware:**
- In Godot, running the "Play" button will build and run the project in the editor, and "Run Current Scene" builds and runs individual scenes that are runnable.

**How to Test:**
- In Godot, there is a tab labeled "GUT" at the bottom of the editor that opens a menu for running selected GUT test files and viewing test diagnostics.

**How to Add New Tests:**
- Under the tests/unit directory add a new test file with the convention "test_[test name].gd" and make sure it extends GutTest.
- Documentation for writing GUT test can be found here: https://gut.readthedocs.io/en/latest/Quick-Start.html#

**How to Build a Release:**
- Load up the project in Godot.
- Navigate to Project->Export... and add export presets for the plaform you want to export to, such as "Web", Windows Desktop", or "MacOS".
- Configure export settings to the platform and then press "Export Project...".
- Run the game.
