import numpy as np
from math import sin, cos,atan, acos, asin
import matplotlib.pyplot as plt

def plot_forward_model(angle1,angle2,color):
    angle1=angle1/180*np.pi
    angle2=angle2/180*np.pi
    lower_arm_length=50
    o1=np.array([-19,0])
    o2=np.array([19,0])
    arm1=np.array([ lower_arm_length*cos(angle1),
                   lower_arm_length*sin(angle1)])
    
    arm2=np.array([ lower_arm_length*cos(angle2),
                   lower_arm_length*sin(angle2)])
    d=(arm2+o2)-(arm1+o1)
    upper_arm_length=50
    height=np.sqrt(upper_arm_length**2-(np.linalg.norm(d)/2)**2)
    d_perp=np.cross(d,[0,0,-1])[0:2]
    d_perp=d_perp/np.linalg.norm(d_perp)*height
    arm3=d/2+d_perp
    arm4=-d/2+d_perp
    plt.quiver(o1[0],o1[1],arm1[0],arm1[1],color=color,angles='xy', scale_units='xy',scale=1)
    plt.quiver(o2[0],o2[1],arm2[0],arm2[1],color=color,angles='xy', scale_units='xy',scale=1)
    plt.quiver(o1[0]+arm1[0],o1[1]+arm1[1],arm3[0],arm3[1],color=color,angles='xy', scale_units='xy',scale=1)
    plt.quiver(o2[0]+arm2[0],o2[1]+arm2[1],arm4[0],arm4[1],color=color,angles='xy', scale_units='xy',scale=1)
    return o1+arm1+arm3

def inverse_model(point):
    theta=np.arctan2(point[1],point[0])
    upper_arm_length=50
    lower_arm_length=50
    o_length=19
    o1=np.array([-19,0])
    o2=np.array([19,0])

    h1=np.linalg.norm(point-o1)
    h2=np.linalg.norm(point-o2)

    y1=(- upper_arm_length**2 + lower_arm_length**2 + h1**2)/(2*h1)
    y2=(- upper_arm_length**2 + lower_arm_length**2 + h2**2)/(2*h2)

    if point[0]<=o2[0]:
        angle2=np.pi-(asin(point[1]/h2)+acos(y2/lower_arm_length))
    else:
        angle2=(asin(point[1]/h2)-acos(y2/lower_arm_length))

    if point[0]>=o1[0]:
        angle1=(asin(point[1]/h1)+acos(y1/lower_arm_length))
    else:
        angle1=np.pi-(asin(point[1]/h1)-acos(y1/lower_arm_length))

    angle1=angle1/np.pi*180
    angle2=angle2/np.pi*180
    return angle1,angle2

def forward_model(angle1,angle2):
    angle1=angle1/180*np.pi
    angle2=angle2/180*np.pi
    lower_arm_length=50
    o1=np.array([-19,0])
    o2=np.array([19,0])
    arm1=np.array([ lower_arm_length*cos(angle1),
                   lower_arm_length*sin(angle1)])
    
    arm2=np.array([ lower_arm_length*cos(angle2),
                   lower_arm_length*sin(angle2)])
    d=(arm2+o2)-(arm1+o1)
    upper_arm_length=50
    height=np.sqrt(upper_arm_length**2-(np.linalg.norm(d)/2)**2)
    d_perp=np.cross(d,[0,0,-1])[0:2]
    d_perp=d_perp/np.linalg.norm(d_perp)*height
    arm3=d/2+d_perp
    return o1+arm1+arm3

if __name__=="__main__":
    import matplotlib.pyplot as plt
    from matplotlib.animation import FuncAnimation
    import numpy as np

    # Dummy forward_model function (replace with your actual function)
    def plot_forward_model(ax, angle1, angle2):
        # Clear existing quivers
        ax.clear()
        ax.set_ylim(-20, 100)
        ax.set_xlim(-60, 60)
        ax.set_aspect('equal')
        
        angle1=angle1/180*np.pi
        angle2=angle2/180*np.pi
        lower_arm_length=50
        o1=np.array([-19,0])
        o2=np.array([19,0])
        arm1=np.array([ lower_arm_length*cos(angle1),
                    lower_arm_length*sin(angle1)])
        
        arm2=np.array([ lower_arm_length*cos(angle2),
                    lower_arm_length*sin(angle2)])
        d=(arm2+o2)-(arm1+o1)
        upper_arm_length=50
        height=np.sqrt(upper_arm_length**2-(np.linalg.norm(d)/2)**2)
        d_perp=np.cross(d,[0,0,-1])[0:2]
        d_perp=d_perp/np.linalg.norm(d_perp)*height
        arm3=d/2+d_perp
        arm4=-d/2+d_perp
        color="blue"

        ax.quiver(o1[0],o1[1],arm1[0],arm1[1],color=color,angles='xy', scale_units='xy',scale=1)
        ax.quiver(o2[0],o2[1],arm2[0],arm2[1],color=color,angles='xy', scale_units='xy',scale=1)
        ax.quiver(o1[0]+arm1[0],o1[1]+arm1[1],arm3[0],arm3[1],color=color,angles='xy', scale_units='xy',scale=1)
        ax.quiver(o2[0]+arm2[0],o2[1]+arm2[1],arm4[0],arm4[1],color=color,angles='xy', scale_units='xy',scale=1)

    # Initialize figure and axis
    fig, ax = plt.subplots()
    ax.set_ylim(-20, 100)
    ax.set_xlim(-60, 60)
    ax.set_aspect('equal')
    ax.set_title("Dynamic Quiver Update with Mouse")

    # Mouse position (initially None)
    mouse_position = [None, None]

    # Function to update mouse position
    def on_mouse_move(event):
        if event.xdata is not None and event.ydata is not None:
            mouse_position[0] = event.xdata
            mouse_position[1] = event.ydata

    # Update the plot
    def update(frame):
        if mouse_position[0] is not None and mouse_position[1] is not None:
            x, y = mouse_position
            angle1,angle2=inverse_model(mouse_position)
            plot_forward_model(ax, angle1, angle2)  # Call forward_model with the current mouse position
        return ax.collections

    # Connect the mouse move event to the handler
    fig.canvas.mpl_connect('motion_notify_event', on_mouse_move)

    # Create the animation
    ani = FuncAnimation(fig, update, frames=200, interval=20, blit=False)

    plt.show()
