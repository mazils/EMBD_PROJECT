import numpy as np

class PathSimplifier():
    def __init__(self,path) -> None:
        self.path=path

    def ComputeSimplifyMap(self):
        bucketList=list()
        for i in range(len(self.path)):
            bucketList.append((i,self.path[i]))
        
        # #First Pass to remove straight line points
        DeviationList=self.ComputeDeviationList(bucketList)
        bindex=1
        for i in range(len(DeviationList)):
            if DeviationList[i][0]<1e-7:
                bucketList.pop(bindex)
            else:
                bindex+=1

        #Algorithm
        NodeMap=list()
        while(len(bucketList)>2):
            DeviationList=self.ComputeDeviationList(bucketList)
            NodeMap.append(DeviationList[0])
            bucketList.pop(DeviationList[0][1])

        #Add End points
        NodeMap.append([NodeMap[-1][0]+100,0,(0,self.path[0])])
        NodeMap.append([NodeMap[-1][0]+100,0,(len(self.path)-1,self.path[-1])])

        self.SimplifyMap=NodeMap

    def ComputeDeviationList(self,path):
        NodeMap=list()

        for i in range(1,len(path)-1):
            deviation=self.ComputeDeviation(path[i-1][1],
                                  path[i][1],
                                  path[i+1][1])
            NodeMap.append((deviation,i,path[i]))

        NodeMap.sort(key=lambda x:(x[0]))
        return NodeMap

    def ComputeDeviation(self,point1,currentPoint,point2):
        point1=point1-currentPoint
        point2=point2-currentPoint
        area=abs(np.cross(point1,point2))
        deviation=2*area/np.linalg.norm(point1-point2)
        return deviation

    def SimplifyPathNodeNummer(self,NodeNumber):
        selectedNodes=self.SimplifyMap[-NodeNumber:]
        selectedPath=list()
        selectedIndexes=list()
        for i in range(len(selectedNodes)):
            selectedPath.append(selectedNodes[i][2][1])
            selectedIndexes.append(selectedNodes[i][2][0])
        sortIndexes=np.argsort(selectedIndexes)
        return np.array(selectedPath)[sortIndexes]

    def SimplifyPathMaxDeviation(self,MaxDeviation):
        selectedPath=list()
        selectedIndexes=list()
        for i in range(len(self.SimplifyMap)):
            if self.SimplifyMap[i][0]>MaxDeviation:
                selectedPath.append(self.SimplifyMap[i][2][1])
                selectedIndexes.append(self.SimplifyMap[i][2][0])
        sortIndexes=np.argsort(selectedIndexes)
        return np.array(selectedPath)[sortIndexes]


if __name__=="__main__":
    from LoadSVG import svg_to_coordinates
    path=svg_to_coordinates("8.svg")
    #path=np.array([[0,0],[1,1.5],[2,2]])
    pSimp=PathSimplifier(path)
    pSimp.ComputeSimplifyMap()
    print(pSimp.SimplifyMap)
    #print(pSimp.SimplifyPathNodeNummer(10))
    #print(pSimp.SimplifyPathMaxDeviation(1))