# MOPED25
## Introduction
* MOPED is the acronym for “Multimodal Occupational Posture Dataset”. '25' stems from 25 different tasks were included in our experiment. 
* We collected posture data from 12 subjects, and 11 of them were published. Each subject was asked to perform 25 different tasks, most of which are commonly seen in a workplace, including bending, squating, lifting, etc.. We collected both the kinematics data as well as the synchronized videos. The kinematics data includes 37 markers (most of which follow the ISB recommendation).
* **Motivation:** I found most of public human pose dataset have vague definition of the key points, like shoulder, hip or wrist, which have limited value for the application of pose detector in a ergonomics or biomechanics perspective. Hopefully, this 'novel' dataset could contribute to the futher application of computer vision in ergo community.
* For a more detailed description of the experiment and the dataset, please refer to our paper (soon).
## Code
* I provided very basic loading and visualizing MATLAB (2019a) code. I haven't tested it in other machines (later), but it should work. No extra packages are needed to run the code. I will keep updating, and add python version later.
* **Usage:** 
  1. Download the data. (Marker data/Videos were stored as .mat/.avi)
  2. Extract the data under folder '\data'. Note that the code used one sample from Sub07 for demo purpose.
  3. Run the the file 'basic_functions.m' block by block. 
## Data downloading (soon)
* The link is provided on our [MOPED25](https://www.ise.ncsu.edu/biomechanics/moped25/) webpage.
