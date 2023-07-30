import tensorflow.compat.v1 as tf
tf.disable_v2_behavior()
import numpy as np
from PIL import Image

from model import utils

class Model:
    def __init__(self, graphPath, checkpointPath, sess):
        '''Initialize network model'''
        # Save tensorflow session
        self.sess = sess
        # Load network graph from graphPath
        saver = tf.train.import_meta_graph(graphPath)
        self.graph = tf.get_default_graph()
        # Load the latest weights from checkpointPath
        saver.restore(sess, tf.train.latest_checkpoint(checkpointPath))

    def predict(self, image):
        '''Predict single image'''
        # Resize image to desired size and preprocessing done during training
        imageSize = 128
        numChannels = 3
        images = []
        pix = Image.fromarray(image, 'RGB')
        pix = pix.resize((imageSize, imageSize), Image.ANTIALIAS)
        image = np.array(pix)

        images.append(image)
        images = np.array(images, dtype=np.uint8)
        images = images.astype('float32')
        images = np.multiply(images, 1.0 / 255.0)

        # Reshape for network input [None imageSize imageSize numChannels]
        xBatch = images.reshape(1, imageSize, imageSize, numChannels)

        # yPred is the tensor predicts (:0 is 0-th element of the batch)
        yPred = self.graph.get_tensor_by_name("yPred:0")

        # Feed image to the input placeholder
        x = self.graph.get_tensor_by_name("x:0")
        yTrue = self.graph.get_tensor_by_name("yTrue:0")
        yTestImages = np.zeros((1, 2))

        # Calculate yPred
        feedDictTesting = {x: xBatch, yTrue: yTestImages}
        result = self.sess.run(yPred, feed_dict=feedDictTesting)

        return result

def create_network_architecture(x, nClasses):
    '''Create computation graph (neural network architecture)'''
    numChannels = 3

    # Labels
    yTrue = tf.placeholder(tf.float32, shape=[None, nClasses], name='yTrue')
    yTrueCls = tf.argmax(yTrue, axis=1)

    # Network graph params
    filterSizeConv1 = 3
    numFiltersConv1 = 32

    filterSizeConv2 = 3
    numFiltersConv2 = 32

    filterSizeConv3 = 3
    numFiltersConv3 = 64

    fcLayerSize = 128

    # Network graph
    layerConv1 = utils.createConvolutionalLayer(
        input=x,
        numInputChannels=numChannels,
        convFilterSize=filterSizeConv1,
        numFilters=numFiltersConv1)

    layerConv2 = utils.createConvolutionalLayer(
        input=layerConv1,
        numInputChannels=numFiltersConv1,
        convFilterSize=filterSizeConv2,
        numFilters=numFiltersConv2)

    layerConv3 = utils.createConvolutionalLayer(
        input=layerConv2,
        numInputChannels=numFiltersConv2,
        convFilterSize=filterSizeConv3,
        numFilters=numFiltersConv3)

    layerFlat = utils.createFlattenLayer(layerConv3)

    layerFc1 = utils.createFcLayer(
        input=layerFlat,
        numInputs=layerFlat.get_shape()[1:4].num_elements(),
        numOutputs=fcLayerSize,
        useRelu=True)

    layerFc2 = utils.createFcLayer(
        input=layerFc1,
        numInputs=fcLayerSize,
        numOutputs=nClasses,
        useRelu=False)

    yPred = tf.nn.softmax(layerFc2, name='yPred')
    yPredCls = tf.argmax(yPred, axis=1)

    return yTrue, yTrueCls, yPred, yPredCls
