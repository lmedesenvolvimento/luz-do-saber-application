export function mergeSelectedRemoteUrlWithNewItems(origin, target) {
    origin.forEach((item) => {
        const itemIndex = target.findIndex(({ word_text }) => word_text === item.word_text)
        target[itemIndex].remote_image_url = item.remote_image_url
    })

    return target
}