# Snore-ganic Chemistry (Grade 12 CS team project)

## Project Description

Snoreganic Chemistry™ is a useful program developed to help high school students ~suffering through~ having fun in organic chemistry. It makes organic chemistry so easy, you could do it in your sleep! The program generates structural line diagrams from the names of organic compounds, taken from user input or selected from a menu of example compounds. The program is also able to capture the window containing a line diagram and save it as an image file for the user to easily use in a document or share with others.

## Features of Snoreganic Chemistry™

Snoreganic Chemistry functions for most organic compound classes covered in grade 12 chemistry, including alkanes, alkenes, alkynes, alcohols, esters, aldehydes, ketones, and carboxylic acids. Possible branches include alkyl, halogen, carbonyl, hydroxyl, oxo, cyclic aliphatic, amino, and nitro branches. The user has the option to colour code the branches by functional group, or view the molecule in black and white.

To create the molecule, the user has two options: pick from a list of examples, or type a valid IUPAC name into the top bar. The bar turns red if a name is invalid.

Once the line structural diagram has been created, the user has the option to save it as a png image or clear the screen and start again.

## Interface Guide

Type a valid IUPAC name for an organic compound, or click the grey button and choose a compound from the list. Your input appears in the grey box at the top of the window. Use the arrow keys to move your cursor (`_`) through the name and edit any part of it. Press the enter (`↵`) key or click the green button to draw your compound’s line structural diagram. 

To switch between molecules with colour-coded functional groups or plain black and white, press the “toggle colour” button. The button will be blue when colour is active and black when colour is disabled.

To save a screenshot of the window, click the yellow button. A png file will be saved to a “Screenshots” folder inside the same folder as the executable. The filename is the name of the compound.

To clear the screen and return to the welcome page, press the red button.

## Molecule and Naming Restrictions

- Standardized IUPAC names only
- No more than 20 carbons in the main chain
- No spaces (except in “-ic acid” ending)
- Only molecular compounds containing the following functional groups are valid:
  - Alkane
  - Alkene
  - Alkyne
  - Cyclic aliphatic (branches only, not base chains)
  - Primary amine
  - Alcohol
  - Ester
  - Aldehyde
  - Ketone
  - Carboxylic acid
