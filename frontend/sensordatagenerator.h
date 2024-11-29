// sensordatagenerator.h
#ifndef SENSORDATAGENERATOR_H
#define SENSORDATAGENERATOR_H

#include <QObject>
#include <QTimer>
#include <QRandomGenerator>
#include <QVariantMap>

class SensorDataGenerator : public QObject
{
    Q_OBJECT

public:
    explicit SensorDataGenerator(QObject *parent = nullptr);

    // Properties for each machine's data
    Q_PROPERTY(QVariantMap risingMachineData READ risingMachineData NOTIFY risingMachineDataChanged)
    Q_PROPERTY(QVariantMap fillingMachineData READ fillingMachineData NOTIFY fillingMachineDataChanged)
    Q_PROPERTY(QVariantMap cappingMachineData READ cappingMachineData NOTIFY cappingMachineDataChanged)
    Q_PROPERTY(QVariantMap labelingMachineData READ labelingMachineData NOTIFY labelingMachineDataChanged)
    Q_PROPERTY(QVariantMap packingMachineData READ packingMachineData NOTIFY packingMachineDataChanged)

    QVariantMap risingMachineData() const { return m_risingMachineData; }
    QVariantMap fillingMachineData() const { return m_fillingMachineData; }
    QVariantMap cappingMachineData() const { return m_cappingMachineData; }
    QVariantMap labelingMachineData() const { return m_labelingMachineData; }
    QVariantMap packingMachineData() const { return m_packingMachineData; }

public slots:
    void startGenerating();
    void stopGenerating();

signals:
    void risingMachineDataChanged();
    void fillingMachineDataChanged();
    void cappingMachineDataChanged();
    void labelingMachineDataChanged();
    void packingMachineDataChanged();
    void errorOccurred(const QString& machine, const QString& error);
    void warningOccurred(const QString& machine, const QString& warning);

private slots:
    void generateNewData();

private:
    QTimer* m_updateTimer;
    QVariantMap m_risingMachineData;
    QVariantMap m_fillingMachineData;
    QVariantMap m_cappingMachineData;
    QVariantMap m_labelingMachineData;
    QVariantMap m_packingMachineData;

    // Helper functions to generate data for each machine
    void updateRisingMachineData();
    void updateFillingMachineData();
    void updateCappingMachineData();
    void updateLabelingMachineData();
    void updatePackingMachineData();

    // Helper function to generate random numbers within range
    double generateInRange(double min, double max);
    int generateIntInRange(int min, int max);
};

#endif // SENSORDATAGENERATOR_H
