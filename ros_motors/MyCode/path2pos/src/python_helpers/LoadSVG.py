from svgpathtools import svg2paths
import numpy as np
import matplotlib.pyplot as plt

def svg_to_coordinates(file_path):
    # Parse SVG file to extract paths
    paths, attributes = svg2paths(file_path)
    
    # List to store all coordinates
    all_coordinates = []

    for path in paths:
        # For each path, sample points
        coordinates = []
        for segment in path:
            # Break the segment into discrete points
            num_points = 50  # You can adjust this to sample more/less points
            for t in np.linspace(0, 1, num_points):
                point = segment.point(t)  # Get a point along the segment
                coordinates.append((point.real, -point.imag))  # Convert complex to (x, y)
        all_coordinates.append(coordinates)

    return np.array(all_coordinates).squeeze()

# Example usage
if __name__ =="__main__":
    file_path = "2.svg"  # Replace with your SVG file path
    coordinates = svg_to_coordinates(file_path)

    plt.plot(coordinates[:,0],coordinates[:,1])
    plt.axis("equal")
    plt.show()
