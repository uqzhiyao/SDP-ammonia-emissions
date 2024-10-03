% Read the image
image = imread('Correlation.jpg'); % Replace with the path to your image file

% Display the image
imshow(image);


% Enable Data Cursor tool
datacursormode on;

% Click on the point of interest to display its coordinates


% Get RGB values at a specific point (e.g., x=100, y=200)
x = 100;
y = 200;
rgb_values = image(y, x, :);

% Display the RGB values
disp('RGB Values at (100, 200):');
disp(rgb_values);