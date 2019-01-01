#include "tasksmodel.h"
#include <QDebug>

Task::Task(QObject* parent)
    : QObject(parent),
      m_label(""),
      m_imageUrl(""),
      m_labelAccessor("")
{
}

Task::Task(const QString& label, QObject* parent)
    : QObject(parent),
      m_label(label)
{
}

void Task::setLabel(const QString& label){
    m_label = label;
}

void Task::setImageData(const QByteArray& imageData){
    m_imageData = imageData;
    m_base64ImageData = m_imageData.toBase64();
}

QByteArray Task::getImageData() const{
    return m_imageData;
}

QString Task::getBase64ImageData() const{
    return m_base64ImageData;
}

QString Task::getLabel() const{
    return m_label;
}

QString Task::getImageUrl() const{
    return m_imageUrl;
}

void Task::setImageUrl(const QString &imageUrl){
    m_imageUrl = imageUrl;
}

void Task::setLabelAccessor(const QString &labelAccessor){
    m_labelAccessor = labelAccessor;
}

QString Task::getLabelAccessor() const{
    return m_labelAccessor;
}


Task::~Task(){

}

TasksModel::TasksModel(QObject* parent)
    : QAbstractListModel(parent)
{
}

TasksModel::~TasksModel(){
    Task* task;
    for(int i = 0; i < m_tasks.size(); i++){
        task = m_tasks[i];
        if(task) delete task;
    }
}

QVariant TasksModel::data(const QModelIndex &index, int role) const{
    QVariant var;
    if(index.isValid()){
        if(role == TasksModel::LabelRole){
            Task* task = m_tasks[index.row()];
            if(task) return task->getLabel();
        } else if(role == TasksModel::ImageDataRole){
            Task* task = m_tasks[index.row()];
            if(task) return task->getImageData();
        } else if(role == TasksModel::Base64ImageDataRole){
            Task* task = m_tasks[index.row()];
            if(task) return task->getBase64ImageData();
        } else if(role == TasksModel::ImageUrlRole){
            Task* task = m_tasks[index.row()];
            if(task) return task->getImageUrl();
        } else if(role == TasksModel::LabelAccessorRole){
            Task* task = m_tasks[index.row()];
            if(task) return task->getLabelAccessor();
        }

    }
    return var;
}

void TasksModel::addTask(Task* f){
    int row = rowCount();
    beginInsertRows(QModelIndex(), row, row);
    m_tasks.append(f);
    endInsertRows();

    countChanged();
}

int TasksModel::rowCount(const QModelIndex &parent) const{
    return m_tasks.size();
}

Task* TasksModel::get(const int index){
    if((index >= 0) && (index < m_tasks.size()))
        return m_tasks[index];
    return 0;
}

QHash<int, QByteArray> TasksModel::roleNames() const{
    QHash<int, QByteArray> roles;
    roles[Qt::DisplayRole] = "display";
    roles[TasksModel::LabelRole] = "label";
    roles[TasksModel::ImageDataRole] = "imageData";
    roles[TasksModel::Base64ImageDataRole] = "base64ImageData";
    roles[TasksModel::ImageUrlRole] = "imageUrl";
    roles[TasksModel::LabelAccessorRole] = "labelAccessor";
    return roles;
}

void TasksModel::update(){
    emit dataChanged(QModelIndex(), QModelIndex());
}

void TasksModel::update(const qint32 index){
    if(index < rowCount()){
        beginRemoveRows(QModelIndex(), index, index);
        endRemoveRows();
        beginInsertRows(QModelIndex(), index, index);
        endInsertRows();
    }
}

void TasksModel::clear(){
    int row = rowCount();
    beginRemoveRows(QModelIndex(), 0, row);
    m_tasks.clear();
    endRemoveRows();

    countChanged();
}
