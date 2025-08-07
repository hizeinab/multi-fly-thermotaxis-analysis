
Title: Multi-Fly Kinematics Extractor from CSV Trajectories and Video Data
Author: Zeinab Moradi
Language: MATLAB
Dependencies: Custom functions: `Add_orientation_Info`, `CurveFitter`, `FD_FirstDerivative_Calculation`, `Curvature_calculation`, 
`DirectionAngle_calculation`, `ReorientationAngle_calculation`, `Distance_calculation`, `Distance_to_Wall`

---

Overview:

This MATLAB script extracts motion features of multiple flies from trajectory data and corresponding video recordings. 
It is designed to work with behavioral assays where individual fly trajectories are tracked over time and saved as `.csv` files.

The script processes these trajectory files and computes a set of kinematic and spatial metrics for each fly, such as:

* Smoothed position trajectory
* Orientation 
* Turning angle (change in orientation between frames)
* Angular velocity (rate of turning angle)
* Speed (magnitude of smoothed velocity vector)
* Acceleration (magnitude of smoothed acceleration vector)
* Curvature (from velocity and acceleration vectors)
* Meander (smoothed turning angle per unit distance)
* Distance traveled (total and per-frame)
* Distance to chamber wall
* Distance to the nearest neighbor fly
* Reorientation angle (frame-to-frame angular change in velocity direction)
* Center of group position (mean fly location per frame)
* Spatial dispersion (distance of each fly to group center)

---

Purpose:

This tool was developed for behavioral analysis of Drosophila melanogaster in circular chambers under thermal conditions. It is particularly useful for:

* Analyzing multi-fly behavior simultaneously
* Quantifying movement features from raw position data
* Extracting group behavior dynamics in social or group assays

---

Inputs:

1. `path_input_csv` — Folder containing fly tracking `.csv` files.
2. `path_input_video` — Folder containing corresponding `.mp4` video files.
3. `n_fly` — Number of flies per video (constant for each dataset).

> Each `.csv` file should include frame-wise tracking data (e.g., `frame`, `id`, `xc`, `yc`), and filenames must include chamber geometry information such as `Cx`, `Cy`, and `R`.


---

How to Use:

1. Set the following variables at the top of the script:

   ```matlab
   n_fly = 6;
   path_input_csv = '...';     % Path to .csv files
   path_input_video = '...';   % Path to .mp4 video files
   ```
2. Run the script in MATLAB.
3. Processed results will be saved in the output folder:
   `.../Feature_Extraction/Output/[Thermal_condition]/[State]/`

---

Notes:

* All smoothing and derivative calculations rely on custom utility functions.
* Chamber center and radius are parsed from filenames (e.g., `Cx510_Cy517_R445`).
* The script handles multiple files in batch and logs timing info for each.


