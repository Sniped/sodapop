// sensordatagenerator.cpp
#include "sensordatagenerator.h"

SensorDataGenerator::SensorDataGenerator(QObject *parent)
    : QObject(parent)
    , m_updateTimer(new QTimer(this))
{
    m_updateTimer->setInterval(1000); // Update every second
    connect(m_updateTimer, &QTimer::timeout, this, &SensorDataGenerator::generateNewData);
}

void SensorDataGenerator::startGenerating()
{
    m_updateTimer->start();
}

void SensorDataGenerator::stopGenerating()
{
    m_updateTimer->stop();
}

double SensorDataGenerator::generateInRange(double min, double max)
{
    return QRandomGenerator::global()->generateDouble() * (max - min) + min;
}

int SensorDataGenerator::generateIntInRange(int min, int max)
{
    return QRandomGenerator::global()->bounded(min, max + 1);
}

void SensorDataGenerator::generateNewData()
{
    updateRisingMachineData();
    updateFillingMachineData();
    updateCappingMachineData();
    updateLabelingMachineData();
    updatePackingMachineData();
}

void SensorDataGenerator::updateRisingMachineData()
{
    // Generate data within specified ranges
    double temperature = generateInRange(60, 80);
    double flow = generateInRange(100, 200);
    double ph = generateInRange(11, 13);

    m_risingMachineData = {
        {"temperature", temperature},
        {"flow", flow},
        {"ph", ph}
    };

    // Check for errors and warnings
    if (temperature > 80) {
        emit errorOccurred("Rising", "Temperature exceeds 80°C");
    } else if (temperature > 75) {
        emit warningOccurred("Rising", "Temperature approaching upper limit");
    }

    if (temperature < 60) {
        emit errorOccurred("Rising", "Temperature falls below 60°C");
    } else if (temperature < 65) {
        emit warningOccurred("Rising", "Temperature approaching lower limit");
    }

    if (ph < 11 || ph > 13) {
        emit errorOccurred("Rising", "pH value outside 11-13 range");
    } else if (ph <= 11.2 || ph >= 12.8) {
        emit warningOccurred("Rising", "pH value trending towards limits");
    }

    if (flow < 100) {
        emit errorOccurred("Rising", "Flow rate below 100 L/min");
    } else if (flow > 180) {
        emit warningOccurred("Rising", "Flow rate above 180 L/min");
    }

    emit risingMachineDataChanged();
}

void SensorDataGenerator::updateFillingMachineData()
{
    double tankLevel = generateInRange(0, 100);
    double fillRate = generateInRange(20, 40);
    double pressure = generateInRange(2, 4);
    double bottleWeight = generateInRange(350, 400);

    m_fillingMachineData = {
        {"tankLevel", tankLevel},
        {"fillRate", fillRate},
        {"pressure", pressure},
        {"bottleWeight", bottleWeight}
    };

    if (tankLevel <= 10) {
        emit errorOccurred("Filling", "Product tank level is 10% or below");
    } else if (tankLevel < 25) {
        emit warningOccurred("Filling", "Product tank level below 25%");
    }

    if (pressure > 4) {
        emit errorOccurred("Filling", "Pressure exceeds 4 bar");
    }
    if (pressure < 2) {
        emit errorOccurred("Filling", "Pressure below 2 bar");
    }

    if (fillRate < 20) {
        emit errorOccurred("Filling", "Fill rate below 20 L/min");
    }

    if (bottleWeight < 350) {
        emit warningOccurred("Filling", "Bottle weight below 350g");
    }

    emit fillingMachineDataChanged();
}

void SensorDataGenerator::updateCappingMachineData()
{
    double torque = generateInRange(0.5, 3.0);
    int capsRemaining = generateIntInRange(0, 10000);

    m_cappingMachineData = {
        {"torque", torque},
        {"capsRemaining", capsRemaining}
    };

    if (torque > 3.0) {
        emit errorOccurred("Capping", "Torque exceeds 3.0 Nm");
    }
    if (torque < 0.5) {
        emit errorOccurred("Capping", "Torque below 0.5 Nm");
    }

    if (capsRemaining == 0) {
        emit errorOccurred("Capping", "Cap supply empty");
    } else if (capsRemaining < 1000) {
        emit warningOccurred("Capping", "Cap supply low");
    }

    emit cappingMachineDataChanged();
}

void SensorDataGenerator::updateLabelingMachineData()
{
    int labelsRemaining = generateIntInRange(0, 10000);
    double positionOffset = generateInRange(-2, 2);
    bool labelQuality = QRandomGenerator::global()->generateDouble() > 0.1; // 90% success rate

    m_labelingMachineData = {
        {"labelQuality", labelQuality},
        {"labelsRemaining", labelsRemaining},
        {"positionOffset", positionOffset}
    };

    if (labelsRemaining == 0) {
        emit errorOccurred("Labeling", "Label supply empty");
    } else if (labelsRemaining < 1000) {
        emit warningOccurred("Labeling", "Label supply low");
    }

    if (std::abs(positionOffset) > 2) {
        emit errorOccurred("Labeling", "Position offset exceeds ±2mm tolerance");
    } else if (std::abs(positionOffset) > 1.5) {
        emit warningOccurred("Labeling", "Position offset trending towards limits");
    }

    if (!labelQuality) {
        emit errorOccurred("Labeling", "Label quality check failed");
    }

    emit labelingMachineDataChanged();
}

void SensorDataGenerator::updatePackingMachineData()
{
    int boxesRemaining = generateIntInRange(0, 10000);
    double boxWeight = generateInRange(4, 5);

    m_packingMachineData = {
        {"boxesRemaining", boxesRemaining},
        {"boxWeight", boxWeight}
    };

    if (boxesRemaining == 0) {
        emit errorOccurred("Packing", "Box supply empty");
    } else if (boxesRemaining < 1000) {
        emit warningOccurred("Packing", "Box supply low");
    }

    if (boxWeight < 4 || boxWeight > 5) {
        emit errorOccurred("Packing", "Packed box weight outside 4-5 kg range");
    } else if (std::abs(boxWeight - 4) < 0.2 || std::abs(boxWeight - 5) < 0.2) {
        emit warningOccurred("Packing", "Box weight trending towards limits");
    }

    emit packingMachineDataChanged();
}
