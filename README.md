# Little Guy Labs
### A game by Greater Frog Games

## Table of Contents
- Project Structure
- Syntax and Styling Guide

## Project Structure

### Directory Structure

There are four primary root directories.

#### 1. elements
Contains all elements that compose a scene.

#### 2. screens
Contains completed scenes such as levels and UI screens.

#### 3. globals
Contains busses, data containers, managers, and utilities for data control.

#### 4. tools 
Contains additional tools that may be of use during development.

## Syntax and Styling Guide

### Directory Naming

Use snake_case for all directories and try to keep them lowercase.

Some other minor rules are as follows:
- All media folders will be named 'assets'
- Group similar directories under encompassing parent directories
- Always adhere to the four primary root directories (elements, screens, globals, tools)

### Commenting

Comments should be written with the following syntax:

```
#name: note
```

This helps keep track of who and what is going on in more confusing code blocks.

### Error Reports

Error reports should be written with the following syntax:

```
printerr("Error (Error Type): Details", var) 
```

The following are valid Error types:
- Data (for missing data / failed data transfer)
- Audio (audio related issues)
