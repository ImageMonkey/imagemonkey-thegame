#ifndef STATSMODEL_H
#define STATSMODEL_H

#include <QAbstractListModel>
#include <QFile>
#include <QJsonDocument>
#include <QTextStream>
#include <QVariant>
#include <QObject>
#include <QJsonArray>
#include <QJsonObject>

class Task : public QObject{
    Q_OBJECT
public:
    Task(QObject* parent = 0);
    Task(const QString& label, QObject* parent = 0);
    Q_INVOKABLE void setLabel(const QString& label);
    Q_INVOKABLE void setLabelAccessor(const QString& labelAccessor);
    Q_INVOKABLE QString getLabel() const;
    Q_INVOKABLE QString getLabelAccessor() const;
    Q_INVOKABLE void setImageData(const QByteArray& imageData);
    Q_INVOKABLE void setImageUrl(const QString& imageUrl);
    Q_INVOKABLE QString getImageUrl() const;
    Q_INVOKABLE QByteArray getImageData() const;
    Q_INVOKABLE QString getBase64ImageData() const;
    ~Task();
private:
    QString m_label;
    QByteArray m_imageData;
    QString m_base64ImageData;
    QString m_imageUrl;
    QString m_labelAccessor;
};

class TasksModel : public QAbstractListModel{
    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
public:
    enum CustomRoles{
        LabelRole = Qt::UserRole,
        ImageDataRole = Qt::UserRole + 1,
        Base64ImageDataRole = Qt::UserRole + 2,
        ImageUrlRole = Qt::UserRole + 3,
        LabelAccessorRole = Qt::UserRole + 4
    };
    TasksModel(QObject* parent = 0);
    ~TasksModel();
    Q_INVOKABLE void addTask(Task* f);
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    Q_INVOKABLE Task* get(const int index);
    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QHash<int, QByteArray> roleNames() const;
    Q_INVOKABLE void update();
    Q_INVOKABLE void update(const qint32 index);
    Q_INVOKABLE void clear();
private:
    QList<Task*> m_tasks;
signals:
    void countChanged();
};

#endif // STATSMODEL_H
