import numpy as np
import matplotlib.pyplot as plt
from numpy import cos,sin

def build_model(angle1,angle2,color):
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
    upper_arm_legnth=50
    height=np.sqrt(upper_arm_legnth**2-(np.linalg.norm(d)/2)**2)
    d_perp=np.cross(d,[0,0,-1])[0:2]
    d_perp=d_perp/np.linalg.norm(d_perp)*height
    arm3=d/2+d_perp
    arm4=-d/2+d_perp
    plt.quiver(o1[0],o1[1],arm1[0],arm1[1],color=color,angles='xy', scale_units='xy',scale=1)
    plt.quiver(o2[0],o2[1],arm2[0],arm2[1],color=color,angles='xy', scale_units='xy',scale=1)
    plt.quiver(o1[0]+arm1[0],o1[1]+arm1[1],arm3[0],arm3[1],color=color,angles='xy', scale_units='xy',scale=1)
    plt.quiver(o2[0]+arm2[0],o2[1]+arm2[1],arm4[0],arm4[1],color=color,angles='xy', scale_units='xy',scale=1)
    print(np.linalg.norm(d)*np.linalg.norm(o1+arm1+arm3))
    return o1+arm1+arm3
# for j in range(1,5):
#     tmp=list()
#     for i in range(20):
#         tmp.append(build_model(135+(i*5/j),45+i,"red"))
#     tmp=np.array(tmp)
#     tmp=tmp-tmp[0]
#     # plt.delaxes()
#     plt.plot(range(len(tmp)),tmp[:,0],label=j)

# plt.legend()
# plt.show()

# for i in range(10):
#     build_model(135+i,45+i,"blue")
# plt.show()

p1=build_model(100,45,"red")

p2=build_model(120,65,"blue")
print(p1-p2)
plt.ylim([-20,100])
plt.xlim([-60,60])
an = np.linspace(0, 2 * np.pi, 100)
plt.plot(70 * np.cos(an), 70 * np.sin(an))


plt.show()

