import numpy as np
from LoadSVG import svg_to_coordinates
from inverse_kinematics import forward_model,inverse_model,plot_forward_model
from PathSimplifier import PathSimplifier
import matplotlib.pyplot as plt



def PreparePath(path):
    start_point=[0,70]#forward_model(110,70)
    path=path-path[0]
    maximum=np.abs(path).max()
    path=path/maximum*10
    return path+start_point
    
#simplify path
def SimplifyPath(path):
    print("original length: ",len(path))
    pSimp=PathSimplifier(path)
    pSimp.ComputeSimplifyMap()
    path=pSimp.SimplifyPathMaxDeviation(0.1)
    print("after simplification: ",len(path))
    return path

def ConvertToAngles(path):
    angle_path=list()
    for i in range(len(path)):
        angle_path.append(inverse_model(path[i]))
    return np.array(angle_path)

def SavePath(angle_path,filepath):
    np.savetxt(filepath, angle_path, delimiter=',', fmt='%.3f')

def ConvertToCoord(angle_path):
    clean_positions=list()
    for i in range(len(angle_path)):
        clean_positions.append(forward_model(angle_path[i,0],angle_path[i,1]))
    return np.array(clean_positions)

if __name__ =="__main__":
    number="26"
    path=svg_to_coordinates("svgs/"+number+".svg")
    plt.subplot(2,1,1)
    plt.plot(path[:,0],path[:,1])
    plt.axis("equal")

    path=PreparePath(path)
    path=SimplifyPath(path)
    angle_path=ConvertToAngles(path)
    SavePath(angle_path,"outputs/"+number+".csv")
    r_path=ConvertToCoord(angle_path)

    plt.subplot(2,1,2)
    plt.plot(r_path[:,0],r_path[:,1])
    plt.axis("equal")
    plt.show()